---
name: scaffold
description: "Scaffold a Swift app in a repo (root if single-stack, else app/): Xcode project + local SwiftPM packages, lint config, Makefile. Used by alphabetsoup:bootstrap or when adding Swift to an existing repo."
---

# Swift scaffold

`<dir>` = repo root (single-stack) or `app/`. `<App>` = app/scheme name. Templates in `${CLAUDE_SKILL_DIR}/templates/`; replace `{{App}}`.

1. The Xcode project must be created by the user in Xcode (File › New › Project, into `<dir>`) — ask them to, unless one exists. Then create `Packages/<App>Core` with `swift package init --type library` and add it to the project as a local package.
2. Enable `SWIFT_STRICT_CONCURRENCY=complete` and Swift 6 language mode on all targets.
3. Copy `Makefile`, `.swiftlint.yml`, `.swift-format`. Set `DEST` to a current simulator (`xcrun simctl list devices available`).
4. Tools: `brew install swiftlint xcresultparser` (swift-format ships with the toolchain as `swift format`).
5. Ensure one Swift Testing test exists in the package so `make check` is green.
6. Append to root `.gitignore`: `xcuserdata/ DerivedData/ .build/ .swiftpm/ reports/ *.xcresult`.
7. Run `make fmt && make check` (normalizes generated files).

No Dockerfile or release job. CI toolchain recipe: `${CLAUDE_SKILL_DIR}/ci.md`.
