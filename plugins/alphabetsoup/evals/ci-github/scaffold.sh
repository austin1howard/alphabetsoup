set -e
git init -q && git remote add origin https://github.com/acme/demo.git
printf '# demo\n\nPython API + Vue SPA.\n\n## Commands\n\n| Command | Does |\n|---|---|\n| `make check` | lint + typecheck + test |\n' > CLAUDE.md
printf '.DEFAULT_GOAL := help\nDOMAINS := backend frontend\n\nsetup lint typecheck test docker-build: ## Run in every domain\n\t@for d in $(DOMAINS); do $(MAKE) -C $$d $@ || exit 1; done\n\ncheck: lint typecheck test ## Done gate\n' > Makefile
mkdir -p backend/src/demo frontend/src
for t in setup lint typecheck test docker-build; do printf '%s: ## %s\n\t@echo %s\n\n' $t $t $t; done > backend/Makefile
cp backend/Makefile frontend/Makefile
printf '[project]\nname = "demo"\nversion = "0.1.0"\ndependencies = ["fastapi", "asyncpg"]\n' > backend/pyproject.toml
echo 3.14 > backend/.python-version && touch backend/uv.lock backend/Dockerfile
printf '{"name":"frontend","private":true,"dependencies":{"vue":"^3.5.0","pinia":"^4.0.0"}}\n' > frontend/package.json
echo 24 > frontend/.nvmrc && touch frontend/package-lock.json frontend/Dockerfile
