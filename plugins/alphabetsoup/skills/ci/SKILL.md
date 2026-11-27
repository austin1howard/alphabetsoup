---
name: ci
description: "Generate or swap CI config (GitHub Actions or GitLab CI) as thin wrappers over make targets: lint, typecheck, test, build, release per domain. Load when setting up, changing, or switching CI. Args: [github|gitlab]."
---

# alphabetsoup:ci

CI knows nothing about languages beyond the toolchain. Every job = toolchain setup → `make setup` → one make target. All logic lives in Makefiles.

## Pipeline (one job per stage per domain, named `<domain> / <stage>`)
| Stage | Target | When |
|---|---|---|
| lint | `make lint` | push to default branch, PR/MR; parallel |
| typecheck | `make typecheck` | parallel; omit for domains with none |
| test | `make test` | parallel; Postgres service if used; JUnit + coverage surfaced in UI |
| build | `make docker-build` | after lint + typecheck + test |
| release | `make docker-build` + push | `v*` tags only |

Name every step (Checkout, Set up toolchain, Install deps, Lint…) so the UI reads cleanly.

## Steps
1. Provider: arg, else `git remote get-url origin` (github.com → github, gitlab → gitlab), else ask.
2. Domains: root (single-stack) or each of `backend/ frontend/ app/` present. For each, read its recipe: `<lang>:scaffold` skill dir `ci.md` (toolchain, cache, typecheck yes/no, report paths).
3. Fill the skeleton in `${CLAUDE_SKILL_DIR}/providers/<provider>/` — repeat domain blocks, substitute `<<…>>`, drop jobs the recipe omits.
   - github → `.github/workflows/ci.yml`, `.github/workflows/release.yml`. Least-privilege `permissions` per job. Pin every action to a commit SHA: `gh api repos/<owner>/<action>/commits/<tag> --jq .sha`, keep `# <tag>` comment.
   - gitlab → `.gitlab-ci.yml`. Pin images to exact versions.
4. Update CLAUDE.md `CI:` line.
5. Validate: `actionlint` (github) / `glab ci lint` (gitlab) if installed; else YAML parse.

## Swap provider
Delete the other provider's files (`.github/workflows/{ci,release}.yml` or `.gitlab-ci.yml`), generate the new one, update CLAUDE.md. Nothing else changes.

## Adding a provider
New `providers/<p>/` skeleton implementing the same pipeline + a `<p>` column in every `<lang>:scaffold/ci.md`.
