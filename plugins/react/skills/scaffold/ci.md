# React CI recipe

| | github | gitlab |
|---|---|---|
| Toolchain | `actions/setup-node` with `node-version-file: .nvmrc`, `cache: npm` | image `node:<.nvmrc>-alpine` (+ `apk add make`) |
| Cache | handled by setup-node | `npm_config_cache: .npm`, key `package-lock.json` |
| Typecheck | `make typecheck` | same |
| Reports | `reports/junit.xml`, `reports/cobertura-coverage.xml` | same |
