---
type: regex
pattern: 'order_total\([^)]*,\s*10\)'
target: {source: file, path: tests/test_pricing.py}
weight: 2
---
