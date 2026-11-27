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
