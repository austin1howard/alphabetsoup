# Swift CI recipe

| | github | gitlab |
|---|---|---|
| Toolchain | `runs-on: macos-latest`; `brew install swiftlint xcresultparser`; select Xcode via `sudo xcode-select -s` if pinned | macOS SaaS runner (`tags: [saas-macos-medium-m1]`, Premium+) or a self-hosted macOS runner. None available → emit jobs with `when: manual` and note it in CLAUDE.md |
| Cache | `~/Library/Developer/Xcode/DerivedData` keyed on `Package.resolved` | same path via `cache:` |
| Typecheck | none — compiler covers it; omit job | same |
| Reports | `reports/junit.xml`, `reports/coverage.xml` (xcresultparser cobertura) | same |
| Build / release | `make build` only; no image, no release job | same |
