---
type: regex
pattern: 'mock|patch\('
flags: i
match: not_contains
target: {source: file, path: tests/test_pricing.py}
---
