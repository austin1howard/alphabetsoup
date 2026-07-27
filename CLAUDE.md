# CLAUDE.md — alphabetsoup maintainer guide

## Layout

```
.claude-plugin/marketplace.json    # catalog (pluginRoot: ./plugins)
shared/
  GROUND_RULES.md                  # universal agent rules (user fills TODOs)
  INTERACTION.md                   # hand-off protocol template
plugins/
  alphabetsoup/                    # core: configuration + coordination skills
  aspen/                           # architect agent (owns specs/)
  gale/ pat/ vic/ randy/           # language/framework agents
    CONVENTIONS.md                 #   per-language "how"; real file, NOT symlinked
.claude/skills/new-plugin/         # maintainer meta-skill (not published)
docs/                              # public GitHub Pages site (served from master:/docs; see docs/CLAUDE.md)
```

The public site lists every agent; `/new-plugin` keeps it in sync. When plugins change, follow `docs/CLAUDE.md`.

## Naming convention

Each plugin is named for a **gender-neutral name sharing the language's first letter**. Agent name = plugin name. Examples: Go → `gale`, Python → `pat`, Vue → `vic`, React → `randy`, architect → `aspen`.

## What vs. how

`specs/` defines *what*; `CONVENTIONS.md` (one per language plugin, real file — not symlinked) defines *how*. Precedence and adoption rules are in `shared/GROUND_RULES.md`.

## Shared rules via symlinks

`shared/GROUND_RULES.md` and `shared/INTERACTION.md` are symlinked into each plugin root. On marketplace install, symlinks are **dereferenced** (content copied) — the sanctioned sharing mechanism.

**Important**: `--plugin-dir` skips symlink dereference. Always test via `/plugin marketplace add ./`, not `--plugin-dir`.

Create symlinks with Bash (Write cannot make symlinks):
```bash
cd plugins/<name>
ln -s ../../shared/GROUND_RULES.md GROUND_RULES.md
ln -s ../../shared/INTERACTION.md INTERACTION.md
```

Verify:
```bash
ls -l plugins/*/GROUND_RULES.md plugins/*/INTERACTION.md
```

## marketplace.json schema notes

Each plugin entry requires a `source` field set to a repo-relative path: `"./plugins/<name>"`. Plain name strings (e.g. `"alphabetsoup"`) fail validation. The top-level `source` field is not part of the schema — omit it.

## No `version` fields

`marketplace.json` and all `plugin.json` files omit `version`. The git commit SHA serves as the version — every push is picked up automatically. A pinned version would require a manual bump per release.

## Authoring standard

**Tokens are expensive.** Every file must be as concise as possible. No preamble, no filler, no restating context. Agent prompts, skill docs, specs — all terse by default.

## Before committing

```bash
claude plugin validate .
claude plugin validate ./plugins/<changed-plugin>
```

Fix all errors. Confirm symlinks resolve correctly with `ls -l plugins/*/GROUND_RULES.md`.

## Adding a new plugin

Run `/new-plugin` in this repo. It guides you through naming, scaffolding, and validation.
