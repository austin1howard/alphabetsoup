"""merge_coverage.py <vitest/vite config> <vitest.coverage.ts template>: insert the coverage block into `test: {`."""

import re
import sys
from pathlib import Path

cfg, tpl = Path(sys.argv[1]), Path(sys.argv[2])
block = tpl.read_text().split("\n", 1)[1].strip()  # drop the leading comment line
s = cfg.read_text()
m = re.search(r"^(\s*)test:\s*\{\n", s, re.M)
if not m:
    sys.exit(f"no `test: {{` block in {cfg}")
indent = m.group(1) + "  "
cfg.write_text(s[: m.end()] + "".join(indent + line + "\n" for line in block.splitlines()) + s[m.end() :])
