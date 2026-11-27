"""Structural checks for the marketplace. Stdlib only. Exit 1 on any failure."""

import json
import re
import subprocess
import sys
from html.parser import HTMLParser
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PLUGINS = ROOT / "plugins"
CORE = "alphabetsoup"
STANDARD_TARGETS = {"help", "setup", "fmt", "lint", "typecheck", "test", "check", "build", "clean"}
NO_DOCKER = {"swift"}
errors: list[str] = []


def err(msg: str) -> None:
    errors.append(msg)


def frontmatter(path: Path) -> dict[str, str]:
    text = path.read_text()
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        return {}
    return dict(re.findall(r"^(\w[\w-]*):\s*(.*)$", m.group(1), re.M))


def check_validate() -> None:
    for target in [ROOT, *sorted(p for p in PLUGINS.iterdir() if p.is_dir())]:
        r = subprocess.run(["claude", "plugin", "validate", str(target)], capture_output=True, text=True)
        if r.returncode != 0:
            err(f"validate failed: {target.relative_to(ROOT) or '.'}\n{r.stdout[-800:]}{r.stderr[-400:]}")


def check_marketplace() -> list[str]:
    mkt = json.loads((ROOT / ".claude-plugin/marketplace.json").read_text())
    names = [p["name"] for p in mkt["plugins"]]
    dirs = sorted(p.name for p in PLUGINS.iterdir() if p.is_dir())
    if sorted(names) != dirs:
        err(f"marketplace plugins {sorted(names)} != plugin dirs {dirs}")
    for p in mkt["plugins"]:
        if p["source"] != f"./plugins/{p['name']}":
            err(f"{p['name']}: source must be ./plugins/{p['name']}")
        pj = PLUGINS / p["name"] / ".claude-plugin/plugin.json"
        if pj.exists() and json.loads(pj.read_text()).get("name") != p["name"]:
            err(f"{pj.relative_to(ROOT)}: name mismatch")
    for f in [ROOT / ".claude-plugin/marketplace.json", *PLUGINS.glob("*/.claude-plugin/plugin.json")]:
        if '"version"' in f.read_text():
            err(f"{f.relative_to(ROOT)}: no version fields (commit SHA is the version)")
    return names


def check_files() -> None:
    for f in PLUGINS.rglob("*"):
        if f.is_symlink():
            err(f"{f.relative_to(ROOT)}: symlinks not allowed (plugins are self-contained)")
    for skill in PLUGINS.glob("*/skills/*/SKILL.md"):
        if not frontmatter(skill).get("description"):
            err(f"{skill.relative_to(ROOT)}: missing description")
    for agent in PLUGINS.glob("*/agents/*.md"):
        fm = frontmatter(agent)
        for key in ("name", "description", "tools"):
            if not fm.get(key):
                err(f"{agent.relative_to(ROOT)}: missing {key}")
    # ${CLAUDE_SKILL_DIR}/x and ${CLAUDE_PLUGIN_ROOT}/x references must resolve
    for md in PLUGINS.rglob("*.md"):
        if md.is_symlink():
            continue
        plugin = PLUGINS / md.relative_to(PLUGINS).parts[0]
        for var, rel in re.findall(r"\$\{(CLAUDE_SKILL_DIR|CLAUDE_PLUGIN_ROOT)\}/([\w./<>-]+)", md.read_text()):
            if "<" in rel:
                continue
            base = md.parent if var == "CLAUDE_SKILL_DIR" else plugin
            if not (base / rel.rstrip("/.")).exists():
                err(f"{md.relative_to(ROOT)}: ${{{var}}}/{rel} does not exist")


def check_languages(names: list[str]) -> None:
    langs = [n for n in names if n != CORE]
    providers = sorted(p.name for p in (PLUGINS / CORE / "skills/ci/providers").iterdir())
    bootstrap = (PLUGINS / CORE / "skills/bootstrap/SKILL.md").read_text()
    readme = (ROOT / "README.md").read_text()
    site = (ROOT / "docs/index.html").read_text()
    for lang in langs:
        base = PLUGINS / lang / "skills"
        for req in ["conventions/SKILL.md", "scaffold/SKILL.md", "scaffold/ci.md", "scaffold/templates/Makefile"]:
            if not (base / req).exists():
                err(f"plugins/{lang}/skills/{req}: missing")
        conv = base / "conventions/SKILL.md"
        if conv.exists():
            desc = frontmatter(conv).get("description", "")
            if "Load before writing, editing, or reviewing" not in desc:
                err(f"{lang}:conventions description must say 'Load before writing, editing, or reviewing ...'")
            body = conv.read_text()
            for sec in ["## Tooling", "## Libraries", "## Patterns", "## Anti-patterns", "## Layout", "## Testing"]:
                if sec not in body:
                    err(f"{lang}:conventions missing section {sec}")
        ci = base / "scaffold/ci.md"
        if ci.exists():
            header = next((line for line in ci.read_text().splitlines() if line.startswith("| |")), "")
            for prov in providers:
                if prov not in header:
                    err(f"plugins/{lang}/skills/scaffold/ci.md: no column for provider '{prov}'")
        mk = base / "scaffold/templates/Makefile"
        if mk.exists():
            targets = set(re.findall(r"^([a-z][\w-]*):", mk.read_text(), re.M))
            want = STANDARD_TARGETS | ({"docker-build", "dev"} if lang not in NO_DOCKER else set())
            if missing := want - targets:
                err(f"plugins/{lang} Makefile missing targets: {sorted(missing)}")
            if lang not in NO_DOCKER and not (base / "scaffold/templates/Dockerfile").exists():
                err(f"plugins/{lang}: Dockerfile template missing")
        if f"| {lang}" not in bootstrap:
            err(f"bootstrap detection table missing '{lang}'")
        if f"`{lang}`" not in readme:
            err(f"README plugin table missing '{lang}'")
        if f"t-{lang}" not in site:
            err(f"docs/index.html missing tile/row for '{lang}'")


class TextOutsideInstall(HTMLParser):
    """Collect visible text outside <section id="install">, <style>, <script>, and command chips."""

    def __init__(self) -> None:
        super().__init__()
        self.stack: list[bool] = []
        self.text: list[str] = []

    VOID = frozenset({"meta", "link", "br", "img", "input", "hr", "source", "wbr"})

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag in self.VOID:
            return
        a = dict(attrs)
        skip = tag in ("style", "script", "head") or a.get("id") == "install" or "chip" in (a.get("class") or "")
        self.stack.append(skip or (bool(self.stack) and self.stack[-1]))

    def handle_endtag(self, tag: str) -> None:
        if self.stack:
            self.stack.pop()

    def handle_data(self, data: str) -> None:
        if not (self.stack and self.stack[-1]):
            self.text.append(data)


def check_site() -> None:
    p = TextOutsideInstall()
    p.feed((ROOT / "docs/index.html").read_text())
    text = " ".join(p.text)
    for hit in re.findall(r"[\w.-]+\.(?:md|json|ya?ml)\b|\b[a-z][\w-]*/(?:[\w-]+/?)*(?=[\s.,;:)]|$)", text):
        err(f"docs/index.html: path/file name outside #install: {hit!r}")


def check_evals(names: list[str]) -> None:
    """Every plugin ships an eval suite that loads cleanly and covers skill triggering."""
    for name in names:
        evals = PLUGINS / name / "evals"
        cases = sorted(d for d in evals.iterdir() if d.is_dir() and d.name != "results") if evals.exists() else []
        if not cases:
            err(f"plugins/{name}: no eval cases (evals/<case>/)")
            continue
        graders = "\n".join(g.read_text() for g in evals.glob("*/graders/*.md"))
        def fires(skill: str) -> bool:
            return re.search(rf"input_match:.*\(\?:{re.escape(name)}:\)\?{re.escape(skill)}\\?\"", graders) is not None
        if name == CORE:
            for sk in sorted((PLUGINS / CORE / "skills").iterdir()):
                fm = frontmatter(sk / "SKILL.md")
                if fm.get("disable-model-invocation") != "true" and not fires(sk.name):
                    err(f"{CORE}:{sk.name} is model-invoked but no eval asserts it fires")
        elif not fires("conventions"):
            err(f"plugins/{name}: no eval asserts {name}:conventions fires")
        if not re.search(r"max:\s*0", graders):
            err(f"plugins/{name}: no negative trigger eval (tool_used Skill with max: 0)")
        # free dry load: cost ceiling 0 parses every case and grader without launching a run
        r = subprocess.run(
            ["claude", "plugin", "eval", str(PLUGINS / name), "--trust-plugin", "--no-publish", "--scaffold",
             "--allow-tools", "Write", "Edit", "--max-cost-usd", "0"],
            capture_output=True, text=True,
        )
        out = r.stdout + r.stderr
        for line in out.splitlines():
            if line.startswith(("✗", "⚠ case")) or "Couldn't load" in line:
                err(f"plugins/{name} evals: {line.strip()}")
        m = re.search(r"× (\d+) cases?", out)
        if not m or int(m.group(1)) != len(cases):
            err(f"plugins/{name} evals: loaded {m.group(1) if m else 0} of {len(cases)} cases")


def main() -> int:
    names = check_marketplace()
    check_files()
    check_languages(names)
    check_site()
    if "--no-validate" not in sys.argv:
        check_validate()
        check_evals(names)
    for e in errors:
        print(f"✘ {e}")
    print(f"lint: {len(errors)} error(s)" if errors else "lint: ok")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
