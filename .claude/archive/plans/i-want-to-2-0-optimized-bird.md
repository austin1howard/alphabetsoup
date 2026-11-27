# alphabetsoup 2.0 — skills, not agents

## Context

v1 models a team: an architect agent, one engineer agent per language, a coordination skill that relays Summary/Requests hand-offs. With Opus/Sonnet 5.5 a single session handles the whole task; the agent churn costs more tokens than it saves. What remains valuable is the *opinion*: coding conventions, testing bar, repo layout, CLAUDE.md shape, Makefile-first commands, standard Docker/CI starting points, and specs as the project's long-lived throughline. 2.0 keeps the marketplace, drops the agent model, and ships those opinions as lightweight skills. The only agents left are two independent reviewers, where a fresh context is the point.

Decisions made with the user:
- Plugins: core `alphabetsoup` + plain-named language plugins `python`, `go`, `vue`, `react`, `swift` (the gender-neutral name scheme is retired).
- Conventions are hybrid: the generated CLAUDE.md inlines the golden rules and tells Claude to load `<lang>:conventions`, and the detail stays in the plugin, so it updates with the marketplace.
- Specs stay canonical, one level higher than v1: product, architecture, domain, features, and decisions. They're kept current as the code changes, not written as per-task hand-off docs.
- Templates: Dockerfiles, CI, an image release on tag (no deploy step), and a local `compose.yaml`. The CI provider is swappable: GitHub and GitLab ship first, and others can be added.
- Walkthrough has three modes: diff walkthrough, codebase tour, and explaining a question or error.
- Agents: a `security-reviewer` and a general `reviewer`.
- Layout: a single-stack project lives at the repo root. `backend/`, `frontend/`, and `app/` appear only when there's more than one stack.

## Target repo shape (this repo)

```
.claude-plugin/marketplace.json
plugins/
  alphabetsoup/
    .claude-plugin/plugin.json
    agents/reviewer.md
    agents/security-reviewer.md
    skills/
      bootstrap/SKILL.md            # user-invoked; new + existing repos
      bootstrap/templates/          # CLAUDE.md, Makefile.root, compose.yaml, gitignore, specs/*
      ci/SKILL.md                   # set up or swap CI provider
      ci/providers/github/          # ci.yml, release.yml (GHCR)
      ci/providers/gitlab/          # .gitlab-ci.yml (check + release stages, GitLab registry)
      standards/SKILL.md            # layout, Makefile targets, CLAUDE.md format, always-do rules
      testing/SKILL.md              # cross-language testing bar
      specs/SKILL.md                # spec structure + when/how to update
      walkthrough/SKILL.md          # diff | tour | explain
      review/SKILL.md               # dispatches the two reviewer agents in parallel
  python/ go/ vue/ react/ swift/
    .claude-plugin/plugin.json
    skills/conventions/SKILL.md     # from v1 CONVENTIONS.md + in-domain layout + testing specifics
    skills/scaffold/SKILL.md        # init commands, which templates to drop where
    skills/scaffold/templates/      # Dockerfile, Makefile, tool config
    skills/scaffold/ci.md           # toolchain recipe per CI provider (see `ci`)
.claude/skills/new-plugin/SKILL.md  # rewritten for the new language-plugin shape
docs/  README.md  CLAUDE.md         # rewritten
```

Removed: `plugins/aspen`, the `plugins/{gale,pat,vic,randy,sol}` names, `shared/` (GROUND_RULES and INTERACTION, plus every symlink to them), and the `configuration` and `coordination` skills. `NOTES.md` is deleted once its items are folded in (see below).

Use `git mv` for renames so history carries over: `plugins/pat/CONVENTIONS.md` → `plugins/python/skills/conventions/SKILL.md`, and likewise for the other four.

## NOTES.md items (all still relevant, folded in)

| Note | Where it lands |
|---|---|
| Config should install the plugins too | `bootstrap` step 1 writes `extraKnownMarketplaces` and `enabledPlugins`, so Claude Code offers to install everything when the folder is trusted. It also prints the `/plugin install …@alphabetsoup` lines as a fallback. |
| `uv init --app --package --name <name> .` | `python:scaffold`, run from the repo root (single-stack) or from inside `backend/`. |
| `npm create vue@latest -y -- --bare --ts --router --pinia --vitest --oxfmt <name>`, then `cd <name> && npm install` | `vue:scaffold`. In a monorepo, `<name>` is `frontend`; single-stack scaffolds into `.`. The `--oxfmt` flag means Vue's conventions switch from Prettier to oxfmt. |
| Add to gitignore | Each `scaffold` appends its language's ignores to the root `.gitignore` instead of leaving a nested one. The core template adds `.claude/settings.local.json` and `.env*` (keeping `!.env.example`). |
| Use plan mode to refine requirements | An always-do rule in `standards` and the CLAUDE.md template: non-trivial work starts in plan mode, and open requirement questions get resolved there with AskUserQuestion. The decisions then land in `specs/` (features, or a decision record) during implementation. `specs` references this too. |
| Marketplace JSON form was wrong | `bootstrap` step 1 uses the object form, and so do the README and the site's install section. |

## Core plugin content

### `standards` (model-invoked when creating or restructuring a repo, adding commands, or editing CLAUDE.md)
- **Layout**: single-stack at the root. Multi-stack uses `backend/`, `frontend/`, and `app/` (native), plus `specs/` and `.github/`. Each domain is self-contained: its own lockfile, tool config, and Makefile. The root holds only shared files.
- **Makefile-first**: every repeated command is a make target. Claude runs `make <target>` instead of the raw tool, and adds a target rather than repeating a raw command. Standard target names are `help` (the default), `setup`, `dev`, `fmt` (writes), `lint` (format check plus linter, read-only), `typecheck` (prints `n/a` where the language has none, e.g. Python), `test` (also writes JUnit and coverage reports to `reports/`), `check` (`lint`, `typecheck`, and `test`: the local done gate), `build`, `docker-build`, `up`, `down`, and `clean`. CI calls each target as its own job. In a multi-stack repo, root targets run `$(MAKE) -C <domain> <target>` across the domains.
- **CLAUDE.md format** (fixed section order): a 1–3 sentence summary → `## Golden rules` → `## Layout` (a tree with one line per directory) → `## Commands` (a table of make targets). Add a domain-level `CLAUDE.md` only when that domain has rules that don't belong at the root.
- **Always-do**: start non-trivial work in plan mode and refine requirements there; keep CLAUDE.md current when layout, commands, or rules change; update `specs/` in the same change that alters behavior or contracts; `make check` must be green before calling anything done; ask before adding a dependency; when existing code conflicts with the conventions, ask rather than silently adopting it (the precedence rule from v1 GROUND_RULES).

### `testing`
Carried over from v1 GROUND_RULES and expanded: tests exercise real behavior, not coverage padding; coverage ≥ 80% is enforced in `make check`; prefer real dependencies (a Postgres container, an httpx/ASGI test client) over mocks of code you own; mock only at external boundaries; every bug fix ships a regression test that fails before the fix; names describe behavior. Per-language specifics live in each `conventions` skill.

### `specs`
Structure:
```
specs/README.md            # product overview: what, who, why; index
specs/architecture.md      # components, data flow, external deps, deployment
specs/domain.md            # entities, invariants, glossary
specs/features/<name>.md   # purpose, behavior, contracts, acceptance criteria
specs/decisions/NNNN-<slug>.md  # ADR-lite: context, decision, consequences
```
Specs describe *what* and *why*, never implementation. They're updated in the same change as the code, so specs and code never disagree on master. A gap in what the code should do → ask the user; a gap in how to do it → follow the conventions and note the choice.

### `bootstrap` (`disable-model-invocation: true`; replaces `configuration`)
1. Write to `.claude/settings.json`: `extraKnownMarketplaces` in the object form from NOTES.md (`{"alphabetsoup":{"source":{"source":"github","repo":"austin1howard/alphabetsoup"}}}`), plus `enabledPlugins` for the core plugin and each detected language. Before writing, confirm the current `enabledPlugins` schema; v1's array form is likely wrong.
2. Detect whether the repo is new or existing, and which stacks it has (the signal table from v1 `configuration`). For a new repo, AskUserQuestion: project name, which stacks, and whether it needs Postgres.
3. For each stack, invoke `<lang>:scaffold`, which runs its init command and places its templates in the root or its domain dir.
4. Root files from `bootstrap/templates/`: Makefile, CLAUDE.md, `.gitignore`, the `specs/` skeleton, and `compose.yaml` (only when there are multiple services or a DB). Then invoke `ci`.
5. On an existing repo, nothing gets overwritten. It reports the gaps against `standards` as a list, then applies the ones the user approves.
6. Finish by running `make check`. It doesn't commit.

### `ci` (model-invocable when setting up or changing CI; args `[github|gitlab]`)
The design that makes providers swappable is that **CI knows nothing about languages beyond the toolchain.** Each job runs `make setup` followed by a single make target, so all the real logic lives in the Makefiles and switching providers means regenerating a thin file.

**Pipeline**, with each stage a separate job per domain so it shows up on its own in the CI UI (e.g. `backend / lint`):

| Stage | Make target | Runs | UI extras |
|---|---|---|---|
| lint | `make lint` | every push/MR, in parallel | — |
| typecheck | `make typecheck` | parallel; job omitted for domains with none | — |
| test | `make test` | parallel; Postgres service when needed | JUnit plus a coverage report, shown as GitHub test summary and artifacts, or GitLab MR test and coverage widgets |
| build | `make docker-build` | after lint, typecheck, and test all pass | image built, not pushed |
| release | `make docker-build` + push | `v*` tags only, after build | — |

Within each job, the steps (checkout, toolchain setup, `make setup`, the target) are named so they're readable in the UI. Lint, typecheck, and test run in parallel to keep feedback fast. Build gates on all three (GitHub `needs`, GitLab `needs` DAG).
- **Provider**: use the arg if one is given. Otherwise detect it from `git remote get-url origin` (github.com → github, gitlab → gitlab), and ask if that's ambiguous.
- **Provider templates** in `ci/providers/<p>/` define the skeleton above: the triggers, per-domain path filters, the registry login, and image tags taken from the git tag.
  - github: `.github/workflows/ci.yml` (lint, typecheck, test, build) and `release.yml` (pushes to GHCR), with least-privilege `permissions` and actions pinned to a SHA.
  - gitlab: `.gitlab-ci.yml` with stages `lint`, `typecheck`, `test`, `build`, `release`, using `rules:changes` per domain and pushing to `$CI_REGISTRY`.
- **Language recipe**: each `<lang>:scaffold/ci.md` holds a small table keyed by provider: the toolchain version file, how to install the toolchain (a GitHub setup action, or a GitLab image), cache paths, whether it has a typecheck, and where its report files go. `ci` fills the provider skeleton with each domain's recipe.
- **Test reports** come from each language's `test` target: pytest `--junitxml` with `--cov-report=xml`, `gotestsum --junitfile` with a cobertura conversion, Vitest's junit reporter with v8 coverage, and `xcodebuild` producing an `xcresult` that's converted to JUnit.
- **Swapping**: delete the old provider's files, generate the new one's, and update the `## Commands`/CI line in CLAUDE.md. Nothing else changes.
- **Adding a provider** means a new `ci/providers/<p>/` directory, plus a row in every language's `ci.md`. `new-plugin` must add rows for all existing providers.
- Swift on GitLab needs macOS runners, so `ci.md` notes that, and when none is available it emits a manual or skip job.

### `walkthrough` (model-invocable, with a narrow description; args `diff|tour|explain [target]`)
- **diff**: get the branch's diff against master (or a PR through `gh`) → state its intent (from commits, the PR, or specs) → show a file map and a reading order (specs → types and contracts → entry points → core logic → tests → infra). Then one stop at a time, each about one function or 40 lines: `file:line`, what it does and why, plus anything Claude finds weak in its own code. Then **wait**. The user can reply `next`, ask to go `deeper`, `skip to X`, or give a change request; change requests are recorded and not applied mid-walk. At the end, recap the feedback list, apply it on approval, and run `make check`.
- **tour**: specs/README → architecture → entry points → one request traced end to end → data layer → tests → build and deploy, pausing between sections.
- **explain**: answer a question by tracing the real code path with `file:line` citations. For an error message, grep for where it originates, walk back through the conditions that lead to it, then give likely causes ranked, with how to confirm each.

### `review` + agents
`/alphabetsoup:review [security|general|both] [target]` dispatches the agents in parallel on the diff, merges and dedupes their findings, presents them ranked, and offers to fix. Both agents are read-only (Read, Grep, Glob, and Bash for git and gh), use `model: inherit`, read the project CLAUDE.md, specs, and the relevant `<lang>:conventions`, and report findings as `file:line`, severity, confidence, and fix.
- `reviewer`: correctness, conformance to the specs, the conventions and anti-patterns, and test quality against `testing`.
- `security-reviewer`: secrets; authn and authz; injection (especially with explicit SQL, so check parameterization); SSRF; unsafe deserialization; dependency pinning and lockfiles; Docker (non-root, no secrets in layers); CI (on GitHub: least-privilege `permissions`, pinned actions, `pull_request_target` misuse; on GitLab: protected/masked variables, pinned images, MR pipelines from forks).

## Language plugins

`conventions` is v1's CONVENTIONS.md, kept as is, plus two new sections: **Layout** (where code goes within the domain) and **Testing** (framework, fixtures, how coverage is enforced). Each description is phrased so the skill triggers whenever Claude writes or reviews code in that language. `scaffold` covers the init command, the templates, and the tool-config defaults.

| Plugin | Init | Layout defaults | Dockerfile | CI recipe (github / gitlab) |
|---|---|---|---|---|
| python | `uv init --app --package --name <name> .` (NOTES) | `src/<pkg>/{api,db,models}`, `tests/` mirrors it | uv multi-stage → python-slim, non-root | setup-uv / `ghcr.io/astral-sh/uv` image |
| go | `go mod init` | `cmd/<name>/`, `internal/<pkg>/`, sqlc queries in `internal/db/queries/` | golang build → distroless static nonroot | setup-go / `golang` image |
| vue | `npm create vue@latest -y -- --bare --ts --router --pinia --vitest --oxfmt <name>` (NOTES) | Vite default: `components/ views/ stores/ composables/` | node build → nginx-unprivileged | setup-node / `node` image |
| react | `npm create vite@latest <name> -- --template react-ts` | `components/ routes/ hooks/ api/` | same as vue | same as vue |
| swift | Xcode project + local SwiftPM `Packages/` | app target thin; features in `Packages/<Feature>` | — | macOS runner / macOS runner (manual if none); no release job |

Vue: the NOTES scaffold uses `--oxfmt`, so switch Vue's formatter from Prettier to oxfmt to match.

## Maintainer docs and site
- `CLAUDE.md`: new layout; naming is "plugin = lowercase language name"; the symlink section and `shared/` are dropped; no `version` fields (unchanged); keep the validate-before-commit steps.
- `.claude/skills/new-plugin`: scaffold `conventions` and `scaffold` skills plus templates, add the plugin to marketplace.json and to the bootstrap detection table, and update the site.
- `README.md`: rewrite around the 2.0 thesis (one session, shared opinions, a familiar look and feel for review), with install steps, the skill list, and the language list.
- `docs/index.html` and `docs/CLAUDE.md`: keep the design system and the language hues. Replace the agent roster and coordination framing with skills and language cards, keeping the opinionated convention tags. Drop `aspen` styling.

## Execution order
1. Restructure the plugins (git mv, deletions, marketplace.json, plugin.json files).
2. Language `conventions` and `scaffold` skills and templates.
3. Core skills, then the agents.
4. Maintainer CLAUDE.md, new-plugin, README, site.
5. Delete NOTES.md.

## Verification
- `claude plugin validate .` and `claude plugin validate ./plugins/<each>` must pass clean.
- In a scratch dir: `/plugin marketplace add <this repo>`, then run `/alphabetsoup:bootstrap` for (a) a new Python-only repo at the root, (b) a new Python + Vue + Postgres monorepo, and (c) an existing repo, where it should report gaps without overwriting anything. Each needs a green `make check`, a successful `docker build`, a valid `compose up`, and workflows that pass `actionlint` (if installed). On (b), push to a scratch GitHub repo and confirm the UI shows separate lint, typecheck, test, and build jobs per domain, with a test summary and coverage. Then run `/alphabetsoup:ci gitlab`: the GitHub files should be removed, a valid `.gitlab-ci.yml` generated (`glab ci lint`, if available), and CLAUDE.md updated.
- Run `/alphabetsoup:walkthrough diff` on this branch, plus `explain` with a sample error string.
- Run `/alphabetsoup:review both` on a scratch diff with a planted SQL injection and a secret, and confirm both are found.
- Run the docs path-leak grep from `docs/CLAUDE.md`, then `open docs/index.html`.
