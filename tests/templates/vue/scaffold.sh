npm create vue@latest -y -- --bare --ts --router --pinia --vitest --eslint --oxfmt frontend >/dev/null
cd frontend
npm install --silent
npm install --silent -D "@vitest/coverage-v8@$(node -p "require('vitest/package.json').version")"
echo 24 > .nvmrc
for f in Makefile Dockerfile nginx.conf .dockerignore; do fill "$f" "$f"; done
python3 "$F/../merge_coverage.py" vitest.config.ts "$T/vitest.coverage.ts"
cp "$F"/*.spec.ts src/__tests__/
