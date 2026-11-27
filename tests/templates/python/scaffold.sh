uv init -q --app --package --name demo .
uv add -q --dev ruff pytest pytest-cov pytest-asyncio
uv add -q 'fastapi[standard]' pydantic structlog
sed 's/{{pkg}}/demo/g' "$T/pyproject.toml" >> pyproject.toml
for f in Makefile Dockerfile .dockerignore; do fill "$f" "$f"; done
cp "$F/main.py" src/demo/main.py
mkdir -p tests && cp "$F/test_main.py" tests/
