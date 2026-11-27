---
type: regex
pattern: 'make check'
match: not_contains
target: {source: file, path: .github/workflows/ci.yml}
---
