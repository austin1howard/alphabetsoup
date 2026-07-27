# Plan: Bootstrap the `alphabetsoup` plugin marketplace

> **GLOBAL CONSTRAINT — TOKENS ARE EXPENSIVE. BE CONCISE AND SUCCINCT ALWAYS.**
> Every authored artifact (agent prompts, skills, ground rules, docs, JSON descriptions) must be as
> short as possible while staying clear. This constraint is itself shipped into the marketplace: it is a
> ground rule every agent follows, and agents must produce terse output (summaries, code comments, PRs).
> No preamble, no restating the request, no filler.

## Context

This repo (`austin1howard/alphabetsoup`) will be a **Claude Code plugin marketplace** distributing
language/framework-specific development plugins. Today it is greenfield (only a README). The pattern:
each supported language/framework maps to one plugin, named for a **gender-neutral name sharing the
language's first letter**, shipping (at minimum) an expert senior-engineer agent of the same name that
builds production-grade code and treats `specs/` as the source of truth. `aspen` is special: the
architect who exclusively creates/updates `specs/`. All agents share common ground rules and a
structured hand-off protocol, and coordinate with each other and the user through an autonomous loop.

Validated against official docs (`code.claude.com/docs/en/{plugins,plugin-marketplaces,plugins-reference}`):
- Marketplace catalog lives at `.claude-plugin/marketplace.json` (repo root); `metadata.pluginRoot` shortens sources.
- Each plugin is a dir with `.claude-plugin/plugin.json`; components (`skills/`, `agents/`) sit at **plugin root**, never inside `.claude-plugin/`.
- Agent files: `agents/<name>.md`, frontmatter `name`/`description`/`model`/`tools`. `${CLAUDE_PLUGIN_ROOT}` substitutes inside agent content.
- Name-only (user-invoked) skills use `disable-model-invocation: true`.
- **Cross-plugin sharing:** plugins are copied to a cache, so `../` refs break. Symlinks to a sibling path *within the same marketplace* are **dereferenced (content copied) on marketplace install** — the sanctioned way to share the ground rules. Caveat: raw `--plugin-dir` skips such symlinks, so test via `/plugin marketplace add ./`.

## Decisions (from interview)
- Shared rules: authored once in `/shared`, **symlinked into each plugin**; agents read `${CLAUDE_PLUGIN_ROOT}/GROUND_RULES.md`.
- Core plugin (houses configuration + coordination skills) named **`alphabetsoup`**.
- Marketplace source slug: **`austin1howard/alphabetsoup`**; owner "Austin Howard".
- Engineer agents use **`model: sonnet`**.
- Both `configuration` and `coordination` are **name-only** skills (user-driven workflows).

## Target layout

```
alphabetsoup/
  .claude-plugin/marketplace.json      # lists all 6 plugins (metadata.pluginRoot: ./plugins)
  shared/
    GROUND_RULES.md                    # USER FILLS IN — universal rules (skeleton + TODOs)
    INTERACTION.md                     # hand-off format + inter-agent protocol
  plugins/
    alphabetsoup/                      # core cross-cutting plugin
      .claude-plugin/plugin.json
      skills/configuration/SKILL.md    # name-only: enable/disable plugins, scaffold repo
      skills/coordination/SKILL.md     # name-only: autonomous agent<->user feedback loop
      INTERACTION.md -> ../../shared/INTERACTION.md   # coordination skill reads the hand-off format
    aspen/  agents/aspen.md            # architect, exclusive owner of specs/
    gale/   agents/gale.md             # Go,    backend/
    pat/    agents/pat.md              # Python, backend/
    vic/    agents/vic.md              # Vue 3, frontend/
    randy/  agents/randy.md            # React, frontend/
      (each language plugin also: .claude-plugin/plugin.json,
       GROUND_RULES.md -> ../../shared/GROUND_RULES.md,
       INTERACTION.md  -> ../../shared/INTERACTION.md)
  .claude/skills/new-plugin/SKILL.md   # THIS repo's meta-skill (standalone, not in marketplace)
  README.md   CLAUDE.md
```

## Work items

### 1. Marketplace catalog — `.claude-plugin/marketplace.json`
`name: "alphabetsoup"`, `owner: {name: "Austin Howard"}`, `metadata.pluginRoot: "./plugins"`, `description`.
`plugins[]` = 6 entries (`alphabetsoup`, `aspen`, `gale`, `pat`, `vic`, `randy`), each `{name, source: "<name>", description}` (pluginRoot resolves `"gale"` → `./plugins/gale`).
**Omit `version`** here and in every `plugin.json` — this is an actively-developed marketplace, so relying
on the git commit SHA means every push is picked up as an update (a pinned `version` would require a manual
bump each release). Optionally add `$schema` for editor validation.

### 2. Shared rules — `shared/`
- `GROUND_RULES.md`: skeleton with `<!-- TODO: fill in -->` placeholders under headers (Source of truth = `specs/`; Scope discipline = stay in your directory; Production-grade bar; Testing; Hand-offs; **Be concise — tokens are expensive**; **Subagent dispatch = no worktrees, no dynamic loops, no two agents in the same area at once**). User completes the TODO headers; the conciseness and subagent-dispatch rules ship pre-written, not as TODOs.
- `INTERACTION.md`: the hand-off contract every agent emits at the end of a turn — a fenced template:
  ```
  ## Summary
  - What was completed this turn (always present). Refs: specs/…, files…

  ## Requests (only if needed — omit this section entirely when nothing is needed)
  - @<agent|user>: explicit request / action item
  - @<agent|user>: … (one or more; may address multiple recipients)
  ```
  Rules: the **Summary is always required**; **Requests is optional** — it is completely fine to have
  nothing to hand off. When present, address one or more specific agents or the user by name with a
  concrete request. Don't fabricate a request just to fill the section.

### 3. Core plugin — `plugins/alphabetsoup/`
- `plugin.json`: `{name: "alphabetsoup", description, author: {name: "Austin Howard"}}` (no `version`).
- Symlink `INTERACTION.md -> ../../shared/INTERACTION.md` so the coordination skill can read the hand-off format from `${CLAUDE_PLUGIN_ROOT}`.
- `skills/configuration/SKILL.md` (frontmatter `description` + `disable-model-invocation: true`): guides the user to
  (a) register the marketplace via `extraKnownMarketplaces` in project `.claude/settings.json` (source `github: austin1howard/alphabetsoup`);
  (b) detect stack (go.mod → gale; *.py/pyproject → pat; package.json deps: `vue` → vic, `react` → randy) and recommend plugins;
  (c) set `enabledPlugins` (e.g. `aspen@alphabetsoup`, `gale@alphabetsoup`);
  (d) scaffold `specs/`, `backend/`, `frontend/` as needed;
  (e) explain `plugin:skill` namespacing. Ends per `INTERACTION.md` (Summary; Requests only if needed).
- `skills/coordination/SKILL.md` (name-only): playbook for the autonomous loop. **Always requires a
  specific request/guidance from the user before starting** — if none was given (e.g. bare
  `/alphabetsoup:coordination`), use `AskUserQuestion` to offer suggestions (e.g. "implement everything
  in specs/", "build the backend for spec X", "wire frontend to the new API") while allowing an
  arbitrary free-text goal. The request may be broad but the user must state the goal/scope up front.
  **Do minimal pre-work** — do not read/analyze specs deeply or pre-determine concrete changes just to
  set up a subagent call. Route the goal to the correct agent(s) (spec work→aspen; backend→gale/pat;
  frontend→vic/randy) and hand them **direction, not decisions** — let each agent inspect `specs/` and
  make its own implementation choices. Dispatch independent work **concurrently only when the agents work
  in different areas** (e.g. backend + frontend at once); **never run two agents in the same area
  simultaneously**, and serialize true dependencies (e.g. aspen's spec before implementers). **Never use
  git worktrees (`isolation: worktree`) or dynamic/self-paced workflows** — plain in-place subagent
  dispatch only. Then collect their Summary/Requests blocks, relay action items between agents/user, and
  iterate until the goal is met or blocked on a user decision. Reads `${CLAUDE_PLUGIN_ROOT}/INTERACTION.md`;
  dispatches plugin agents as subagents by their scoped name (`<plugin>:<agent>`, e.g. `gale:gale`,
  `aspen:aspen` — implementer: confirm the exact scoped form via `/context` after install, since plugin
  name == agent name here).

### 4. Language/framework plugins — `plugins/{aspen,gale,pat,vic,randy}/`
Each: `plugin.json` (name, description, author; no version) + `agents/<name>.md` + two symlinks to the shared rules.
Agent frontmatter: `name`, `description` (specialty + when to invoke + hard directory scope — the
`description` is what drives auto-delegation, so make it specific), `model: sonnet`. **Omit `tools`** to grant
the full toolset; directory scope is enforced by the prompt, not a sandbox (there is no per-dir tool restriction).
Agent body (concise): role as expert senior engineer; **exclusive working directory**; `specs/` is the
source of truth; MUST read `${CLAUDE_PLUGIN_ROOT}/GROUND_RULES.md` and `${CLAUDE_PLUGIN_ROOT}/INTERACTION.md`
before acting; production-grade bar; **terse output — no preamble/filler**; end every turn per `INTERACTION.md` (always a Summary; Requests only if needed).
- `aspen` — architect; **only** touches `specs/`; flexible; creates/updates specs; the others depend on it.
- `gale` Go / `pat` Python → `backend/`; `vic` Vue 3 / `randy` React → `frontend/`.

### 5. This-repo meta-skill — `.claude/skills/new-plugin/SKILL.md`
Standalone, **model-invocable** (description triggers on "create/add a new language plugin"); auto-loads
for maintainers here; not published. Scaffolds a new language plugin: prompts for the language/framework,
then **suggests several gender-neutral name options sharing its first letter (via `AskUserQuestion`) while
allowing the user to enter their own** (verify uniqueness against existing plugins). Creates
`plugins/<name>/{.claude-plugin/plugin.json,agents/<name>.md}` (agent modeled on the existing engineer
agents), creates the two shared-rule symlinks via `ln -s` (**Bash, not Write — Write can't make symlinks**;
they commit to git as symlinks), appends the entry to `marketplace.json`, and reminds to run
`claude plugin validate .`.

### 6. Docs — `README.md`, `CLAUDE.md`
- `README.md`: what the marketplace is; add/install (`/plugin marketplace add austin1howard/alphabetsoup`, `/plugin install <name>@alphabetsoup`); plugin/agent catalog table; the `alphabetsoup:configuration` + `alphabetsoup:coordination` workflows; specs-as-source-of-truth + hand-off model; how to add a new language plugin (the meta-skill).
- `CLAUDE.md`: maintainer conventions for this repo — layout, the symlink-sharing rule + `--plugin-dir` caveat, naming convention (gender-neutral, shared first letter, agent name = plugin name), `claude plugin validate .` before commit, concise/token-frugal authoring.

## Implementation notes / gotchas
- **Symlinks**: create with `ln -s ../../shared/<file> plugins/<name>/<file>` (Bash) — relative, so they
  resolve within the marketplace and dereference on install. Write tool cannot create symlinks. Verify with `ls -l`.
- **Scope is prompt-enforced**, not sandboxed — the agent bodies must state the exclusive directory firmly.
- **`gale` vs `pat`** (both `backend/`) and **`vic` vs `randy`** (both `frontend/`): disambiguated by task
  language/framework, expressed in each agent's `description` so delegation picks correctly.
- **Bootstrapping order for a consumer**: `/plugin marketplace add austin1howard/alphabetsoup` → install +
  enable `alphabetsoup` → run `/alphabetsoup:configuration`. Document this in README.
- **Subagent dispatch rules (apply everywhere agents are spawned)**: never git worktrees
  (`isolation: worktree`), never dynamic/self-paced loops; concurrent agents are fine only when they work in
  different areas — never two in the same area at once. Bake this into `GROUND_RULES.md` too.
- **Build order** for the implementer: shared/ → core plugin → one engineer plugin (aspen) end-to-end and
  validate → replicate to the other four → meta-skill → docs. Validate after each plugin.

## Reuse / conventions
- No existing code to reuse (greenfield). Follow official schemas exactly (validated above).
- Every authored file terse by default (see Global Constraint); prefer tables/bullets over prose.

## Verification
1. `claude plugin validate .` at repo root — catalog schema + each local plugin's `plugin.json`/frontmatter.
2. `claude plugin validate ./plugins/<name>` for each plugin.
3. Local end-to-end (exercises symlink dereference, unlike `--plugin-dir`):
   `/plugin marketplace add ./` → `/plugin install gale@alphabetsoup` → confirm `gale` appears in `/context` (Custom Agents) and `${CLAUDE_PLUGIN_ROOT}/GROUND_RULES.md` resolved in its cache copy.
4. `/plugin install alphabetsoup@alphabetsoup`, run `/alphabetsoup:configuration` in a scratch repo and confirm it writes `enabledPlugins`/`extraKnownMarketplaces` and scaffolds dirs.
5. `ls -l plugins/*/GROUND_RULES.md plugins/*/INTERACTION.md` — confirm symlinks point into `shared/`.
6. Enable a couple agents, run `/alphabetsoup:coordination` with a small goal in a scratch repo — confirm it
   asks for a goal when none given, dispatches the right agent(s), and relays Summary/Requests back.
7. Run the `new-plugin` meta-skill for a throwaway language; re-run `claude plugin validate .`; delete it.
