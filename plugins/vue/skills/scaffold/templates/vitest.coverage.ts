// Merge into the `test` block of vite.config.ts / vitest.config.ts
coverage: {
  provider: 'v8',
  include: ['src/**/*.{ts,vue}'],
  exclude: ['src/**/__tests__/**', 'src/**/*.{spec,test}.*', 'src/main.*'],
  reporter: ['text', 'cobertura'],
  reportsDirectory: 'reports',
  thresholds: { lines: 80, branches: 80, functions: 80, statements: 80 },
},
