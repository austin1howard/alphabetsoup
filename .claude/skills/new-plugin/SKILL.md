---
description: "Create a new language or framework plugin in this marketplace. Invoke when asked to add or create a new language plugin."
---

# new-plugin

Scaffold a new language/framework plugin for the alphabetsoup marketplace.

## Step 1 — Get the language/framework

If not already stated, ask: "Which language or framework is this plugin for?"

## Step 2 — Suggest names

Suggest 3–4 gender-neutral names sharing the language's first letter, via `AskUserQuestion`. Also offer a free-text option so the user can provide their own.

Check existing plugins to avoid duplicates:
```bash
ls plugins/
```

Examples of the naming pattern: Go → `gale`; Python → `pat`; Vue → `vic`; React → `randy`; Rust → `river`/`robin`/`reese`; Java → `jules`/`jade`; TypeScript → `taylor`/`tatum`.

## Step 3 — Create the plugin

Once a name is confirmed, scaffold:

```bash
mkdir -p plugins/<name>/.claude-plugin plugins/<name>/agents
```

Create `plugins/<name>/.claude-plugin/plugin.json`:
```json
{
  "name": "<name>",
  "description": "<Language/Framework> engineer agent. Implements <language> code in <directory>/ from specs/.",
  "author": { "name": "Austin Howard" }
}
```

Create `plugins/<name>/agents/<name>.md` modeled on an existing engineer agent (e.g. `plugins/gale/agents/gale.md`). Customize: language/framework name, working directory. The agent prompt only points to `CONVENTIONS.md` — language-specific opinions live there, not inline.

Create `plugins/<name>/CONVENTIONS.md` — a **real file, never symlinked** — using this template:

```markdown
# <Language> Conventions

## Tooling
- ...

## Libraries (default picks)
- <purpose> → <library>

## Patterns to enforce
- ...

## Anti-patterns
- ...
```

Create symlinks (use Bash, not Write):
```bash
cd plugins/<name>
ln -s ../../shared/GROUND_RULES.md GROUND_RULES.md
ln -s ../../shared/INTERACTION.md INTERACTION.md
```

## Step 4 — Register in marketplace catalog

Append to the `plugins[]` array in `.claude-plugin/marketplace.json`:
```json
{
  "name": "<name>",
  "source": "./plugins/<name>",
  "description": "<Language/Framework> engineer agent. Implements <language> code in <directory>/ from specs/."
}
```

## Step 5 — Update the landing page

The public site at `docs/index.html` lists every agent. Follow `docs/CLAUDE.md` → "Adding a plugin" to keep it in sync. In short, edit `docs/index.html`:
1. Add a `--<name>` hue var in `:root` (a color from the language's identity).
2. Bind it: add `.t-<name>` and `.agent.t-<name>` to the hue-class lines.
3. Add a hero `.tile` for the agent to `.roster`.
4. Add an `.agent` row to the matching `.domain` in the Plugins section (new `.domain` card if the domain is new), with a `.tags` block of 3–5 opinionated picks from the new `CONVENTIONS.md` (specific libraries and negations like "no ORM" — not generic advice). Class each tag `lib`, `rule`, or `anti` (see `docs/CLAUDE.md`).

Preview with `open docs/index.html` and confirm no filesystem paths leaked outside the Install section.

## Step 6 — Validate

Run:
```bash
claude plugin validate .
claude plugin validate ./plugins/<name>
```

Fix any reported errors before finishing.

---

## Summary
- Scaffolded `plugins/<name>/` with plugin.json, agent, and shared-rule symlinks.
- Registered in marketplace.json.
- Updated `docs/index.html` landing page (per `docs/CLAUDE.md`).
- Ran `claude plugin validate`.
