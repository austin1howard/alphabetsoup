# Python CI recipe

| | github | gitlab |
|---|---|---|
| Toolchain | `astral-sh/setup-uv` (`enable-cache: true`); Python from `.python-version` | image `ghcr.io/astral-sh/uv:python3.14-trixie-slim` (+ `apt-get install -y make`) |
| Cache | handled by setup-uv | `UV_CACHE_DIR: .uv-cache`, cache key `uv.lock` |
| Typecheck | none — omit job | none — omit job |
| Reports | `reports/junit.xml`, `reports/coverage.xml` (cobertura) | same |
