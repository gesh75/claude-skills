---
name: cicd-pipeline-builder
description: Build CI/CD pipelines with GitHub Actions. Covers test automation, caching, matrix builds, artifact reuse, and deployment.
category: Cloud & DevOps
version: 1.0.0
---

# CI/CD Pipeline Builder

## Minimal Pipeline
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: npm }
      - run: npm ci && npm test && npm run build
```

## Caching
```yaml
- uses: actions/setup-node@v4
  with: { node-version: 20, cache: npm }   # built-in
- uses: actions/cache@v4                    # manual
  with:
    path: ~/.npm
    key: ${{ runner.os }}-${{ hashFiles('**/package-lock.json') }}
```

## Matrix Builds
```yaml
strategy:
  matrix: { node: [18, 20, 22], os: [ubuntu-latest, windows-latest] }
```

## Artifact Reuse
```yaml
# build job:  upload-artifact name: dist, path: dist/
# deploy job: download-artifact name: dist
```

## Deploy on Main Only
```yaml
if: github.ref == 'refs/heads/main' && github.event_name == 'push'
environment: { name: production, url: https://myapp.com }
env:
  API_KEY: ${{ secrets.API_KEY }}
```

## Key Actions
| Action | Purpose |
|---|---|
| `actions/checkout@v4` | Clone repo |
| `actions/setup-node@v4` | Node + npm cache |
| `actions/cache@v4` | Custom caching |
| `actions/upload-artifact@v4` | Save build output |
| `docker/build-push-action@v5` | Docker build + push |
