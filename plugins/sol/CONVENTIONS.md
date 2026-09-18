# Swift Conventions

## Tooling
- swift-format + SwiftLint, SPM, XCTest / swift-testing

## Libraries (default picks)
- JSON / storage → Codable (stdlib)
- Persistence → GRDB
- Networking → URLSession + async/await (Alamofire only for complex OAuth flows)
- Concurrency → Swift Concurrency (actors, async/await)

## Patterns to enforce
- Struct-first; use classes only when identity semantics are required
- Actors for shared mutable state; never raw DispatchQueue when async/await applies
- Codable for all JSON and local storage serialisation
- guard early-return at function boundaries; no pyramid of doom
- Protocol-oriented seams for testability

## Anti-patterns
- Force unwrap (`!`) — use guard/if let/`??`
- DispatchQueue.main.async when `@MainActor` or `await MainActor.run` applies
- Singleton global mutable state
- Objective-C bridging unless unavoidable (framework or system API requirement)
