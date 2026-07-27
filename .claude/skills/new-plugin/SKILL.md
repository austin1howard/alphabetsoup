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

Create `plugins/<name>/agents/<name>.md` modeled on an existing engineer agent (e.g. `plugins/gale/agents/gale.md`). Customize: language/framework name, working directory, language-specific standards (linter, test framework, idioms).

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
  "source": "<name>",
  "description": "<Language/Framework> engineer agent. Implements <language> code in <directory>/ from specs/."
}
```

## Step 5 — Validate

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
- Ran `claude plugin validate`.
