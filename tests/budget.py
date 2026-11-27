"""Fail if any plugin's always-on token cost (added to every session) exceeds its ceiling."""

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CEILINGS = {"alphabetsoup": 1000}  # tokens; core carries 7 skills + 2 agents
DEFAULT = 200  # per language plugin: two skill descriptions


def always_on(plugin: str) -> int:
    out = subprocess.run(
        ["claude", "--plugin-dir", str(ROOT / "plugins" / plugin), "plugin", "details", plugin],
        capture_output=True, text=True, check=True,
    ).stdout
    m = re.search(r"Always-on:\s+~([\d.]+)(k?)\s*tok", out)
    if not m:
        sys.exit(f"budget: could not parse `plugin details` output for {plugin}:\n{out}")
    return int(float(m.group(1)) * (1000 if m.group(2) else 1))


def main() -> int:
    failed = False
    for d in sorted((ROOT / "plugins").iterdir()):
        cost, limit = always_on(d.name), CEILINGS.get(d.name, DEFAULT)
        ok = cost <= limit
        failed |= not ok
        print(f"{'✔' if ok else '✘'} {d.name:<14} ~{cost:>5} / {limit} tok always-on")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
