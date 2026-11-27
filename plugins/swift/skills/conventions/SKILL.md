---
name: conventions
description: "Swift coding conventions: tooling, UI framework, library picks, patterns, layout, testing. Load before writing, editing, or reviewing any Swift code."
---

# Swift Conventions

## Tooling
- swift-format + SwiftLint, Swift 6 strict concurrency (`SWIFT_STRICT_CONCURRENCY=complete`)
- SwiftPM packages inside the Xcode app project (not standalone executables)
- Swift Testing; XCTest only for UI/integration tests that require it

## UI framework
- SwiftUI by default
- AppKit for performance-critical paths (custom drawing, high-frequency updates)
- No third-party UI frameworks

## Libraries (default picks)
- JSON / storage → Codable (stdlib)
- Persistence → GRDB
- Networking → URLSession + async/await

## Patterns to enforce
- Struct-first; use classes only when identity semantics are required
- Actors for shared mutable state; `@MainActor` for UI-bound state
- Codable for all JSON and local storage serialisation
- guard early-return at function boundaries; no pyramid of doom
- Protocol-oriented seams for testability

## Anti-patterns
- Force unwrap (`!`) — use guard/if let/`??`
- `DispatchQueue.main.async` — use `@MainActor` or `await MainActor.run`
- Singleton global mutable state
- Objective-C bridging unless unavoidable (framework or system API requirement)

## Layout
```
<App>.xcodeproj
<App>/                 # app target: thin — App entry, root scene, DI wiring
Packages/<Feature>/    # local SwiftPM packages; all real code lives here
  Sources/<Feature>/
  Tests/<Feature>Tests/
```

## Testing
- Swift Testing (`@Test`, `#expect`) in each package's Tests target; `swift test` per package where no UIKit/AppKit dependency.
- App-level and UI tests via `xcodebuild test`; result bundle to `reports/`, converted to JUnit (xcresultparser).
- Coverage ≥ 80% on packages.
