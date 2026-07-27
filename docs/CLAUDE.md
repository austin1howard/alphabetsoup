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
- **No filesystem paths or file names** anywhere except the Getting Started / Install steps. Say "domain," not `backend/`; never name `specs/`, `INTERACTION.md`, etc. outside Install. The only path allowed elsewhere is none — check with `grep -nE '/|\.md|\.json' index.html` and confirm every hit is inside `#install`.
- **Terse.** Same authoring standard as the rest of the repo.
- `aspen` in prose is wrapped in `<span class="aspen">` so it renders in its hue.

## Design system

Defined once in `:root` (top of `<style>`):

- **Base palette** — warm ink background (`--ink`), warm-bone text (`--bone`), hairline borders (`--line`). Everything structural is monochrome.
- **Agent hues** — one CSS var per agent (`--aspen`, `--gale`, `--pat`, `--randy`, `--vic`), each drawn from its language's own identity (Go cyan, Python gold, Vue green, React cyan, blueprint indigo for the architect). Color appears **only** on agent initials/names and on the convention tags — nowhere else. Don't add accent color beyond those.
- **Convention tags** — three subtle category tints: `.tag.lib` (library, indigo), `.tag.rule` (pattern, green), `.tag.anti` (anti-pattern, rose). Kept low-saturation on purpose. Tags sit beside the name in the two domain columns; in the full-width specs strip they wrap centered below (CSS handles this). Keep each tag one line — they `white-space:nowrap`.
- **Type** — Bricolage Grotesque (display + letters), Hanken Grotesk (body), JetBrains Mono (commands/labels).

## Page structure (in order)

1. **Hero** — thesis headline + lede + CTAs; the **roster** (`.roster`) of monogram tiles, one `.tile` per agent + one `.t-core` tile.
2. **Design** (`#why`) — agent-vs-human framing + four decision `.card`s. Not per-plugin; edit only if the coordination model changes.
3. **Plugins** (`#cast`) — the domain layout: `.core-strip` (alphabetsoup) on top, `.domains` grid (backend / frontend columns) in the middle, `.domain.full` (specs / aspen) stretched below. Each agent is an `.agent` row with a colored `.ini` initial.
4. **Install** (`#install`) — the two setup steps. Only place paths/commands live.
5. **Skills** (`#workflows`) — the two slash commands.
6. **Footer.**

## Adding a plugin

When `/new-plugin` creates agent `<name>` for `<Language>` in domain `<backend|frontend|…>`, make five edits to `index.html`:

1. **Hue var** — in `:root`, add `--<name>:#RRGGBB;` using a color from the language's identity, distinct from existing hues.
2. **Hue class bindings** — add `.t-<name>{--hue:var(--<name>)}` to the `.tile.t-*` line (~L115) **and** `.agent.t-<name>{--hue:var(--<name>)}` to the `.agent.t-*` lines (~L170).
3. **Hero tile** — add a `<div class="tile t-<name>">` to `.roster` (copy an existing tile; set glyph to the initial, `.nm` to the name, `.role` to `<Language> · <domain>`).
4. **Stagger** (optional polish) — extend the `.anim .tile:nth-child(N)` delays so the new tile is covered; add ~`.06s` per index.
5. **Domain column** — add an `.agent` row to the matching `.domain` in `#cast`, including a `.tags` block of 3–5 `.tag`s. Pull those from the plugin's `CONVENTIONS.md`: pick the **genuinely opinionated** picks (specific libraries, and especially the negations — "no ORM", "no Options API"), never generic advice. Class each tag by category: `lib` (library pick), `rule` (pattern to enforce), or `anti` (anti-pattern / "no X"), e.g. `<span class="tag anti">no ORM</span>`. Keep tags short: a `lib` tag is just the library name (no parenthetical "why"); trim `rule`/`anti` to the shortest phrase that keeps the meaning. Order them so adjacent tags are different categories — colors should interleave, not cluster. If the domain is new, add a `.domain` card (and confirm `.domains` still fits — it is a 2-col grid; widen to `repeat(3,1fr)` if needed).

Also refresh the concrete example in the Plugins section subhead ("gale for Go, pat for Python, randy for React") if it goes stale.

## Changing / removing a plugin

- **Rename** — update the tile, the domain-column row, the hue var/class names, and any prose mention. Grep the old name: `grep -n '<oldname>' index.html`.
- **Remove** — delete its tile, its domain-column row, its hue var and both `.t-<name>` bindings. Fix the stagger nth-child count.
- **Retarget domain** — move the `.agent` row to the new `.domain`; update the tile `.role`.

## Before committing

- Preview: `open docs/index.html`.
- Confirm every agent in `.claude-plugin/marketplace.json` has a tile and a domain row, and no removed agent lingers.
- Re-run the path-leak grep above.
