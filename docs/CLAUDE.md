# CLAUDE.md — docs/ landing page

The public GitHub Pages site. Keep it in sync when plugins are added, renamed, or removed.

## Publishing

- Served from `master:/docs`. Every push republishes — no build step, no Action.
- Live URL: `https://austin1howard.github.io/alphabetsoup/`.
- `.nojekyll` disables Jekyll. Leave it.

## Files

- `index.html` — the entire site. Self-contained: all CSS/JS inline. Only external load is Google Fonts (`<link>` in `<head>`).
- `.nojekyll` — empty marker.

## Content rules

- **Audience is engineers.** State the mechanic plainly; no marketing register, no hype.
- **No filesystem paths or file names** outside `#install`. Say "domain," not `backend/`; "project guide," not `CLAUDE.md`. Slash-command chips are fine. Check: `grep -nE '/|\.md|\.json' index.html` — every non-URL, non-tag hit must be in `#install` or a command chip.
- **Terse.** Same authoring standard as the rest of the repo.

## Design system

Defined once in `:root` (top of `<style>`):

- **Base palette** — warm ink background (`--ink`), warm-bone text (`--bone`), hairline borders (`--line`). Everything structural is monochrome. `--accent` is for selection and focus ring only.
- **Language hues** — one CSS var per language plugin (`--go`, `--python`, `--react`, `--vue`, `--swift`), from the language's own identity. Color appears **only** on language initials/names and convention tags.
- **Convention tags** — `.tag.lib` (library, indigo), `.tag.rule` (pattern, green), `.tag.anti` (anti-pattern, rose). Low-saturation on purpose. One line each (`white-space:nowrap`).
- **Type** — Bricolage Grotesque (display + letters), Hanken Grotesk (body), JetBrains Mono (commands/labels).

## Page structure (in order)

1. **Hero** — thesis + lede + CTAs; `.roster` of monogram tiles, one `.tile.t-<lang>` per language + one `.t-core`.
2. **Design** (`#why`) — one-session framing + four `.card`s. Edit only if the model of the marketplace changes.
3. **Plugins** (`#cast`) — `.domains` grid (backend / frontend / native), one `.agent` row per language with `.ini` + `.tags`; `.domain.full` core strip below with the core plugin's tags.
4. **Install** (`#install`) — two steps. Only place paths live.
5. **Skills** (`#workflows`) — the user-invoked core commands (`.flow` cards).
6. **Footer.**

## Adding a language

When `/new-plugin` creates `<lang>` in domain `<backend|frontend|native|…>`, edit `index.html`:

1. **Hue var** — `--<lang>:#RRGGBB;` in `:root`, distinct from existing hues.
2. **Hue bindings** — `.t-<lang>{--hue:var(--<lang>)}` on the `.t-*` tile line **and** `.agent.t-<lang>{...}` on the `.agent.t-*` line.
3. **Hero tile** — `<div class="tile t-<lang>">` in `.roster`: glyph = initial, `.nm` = plugin name, `.role` = domain. Extend `.anim .tile:nth-child(N)` delays (~`.06s` each) if needed.
4. **Domain row** — `.agent.t-<lang>` in the matching `.domain` with 3–5 `.tag`s taken from its `conventions` skill: the **genuinely opinionated** picks (specific libraries, negations like "no ORM"), never generic advice. `lib` tags are just the library name; trim `rule`/`anti` to the shortest phrase. Interleave categories. New domain → new `.domain` card (grid is 3 columns).

## Changing / removing

- **Rename** — tile, domain row, hue var/classes, prose. `grep -n '<old>' index.html`.
- **Remove** — tile, row, hue var, both bindings; fix stagger.
- **New core command** — add a `.flow` card in `#workflows`.

## Before committing

- Preview: `open docs/index.html`.
- Every plugin in `.claude-plugin/marketplace.json` has a tile and row; nothing removed lingers.
- Re-run the path-leak grep.
