CI=1 npm create vite@latest frontend -- --template react-ts </dev/null >/dev/null
cd frontend
npm install --silent
npm install --silent zustand @tanstack/react-query react-router
npm install --silent -D prettier vitest @testing-library/react @testing-library/jest-dom @testing-library/user-event jsdom
npm install --silent -D "@vitest/coverage-v8@$(node -p "require('vitest/package.json').version")"
echo 24 > .nvmrc
cp "$F/vite.config.ts" vite.config.ts
python3 "$F/../merge_coverage.py" vite.config.ts "$T/vitest.coverage.ts"
for f in Makefile Dockerfile nginx.conf .dockerignore; do fill "$f" "$f"; done
cp "$F/setup.ts" src/test-setup.ts
cp "$F/App.test.tsx" src/
