# TDD Workflow — Coverage & CI/CD

Coverage thresholds, continuous-testing commands, and CI integration. Referenced from SKILL.md "Verify Coverage" and "Continuous Testing".

---

## Run Coverage Report

```bash
npm run test:coverage
```

## Coverage Thresholds

```json
{
  "jest": {
    "coverageThresholds": {
      "global": {
        "branches": 80,
        "functions": 80,
        "lines": 80,
        "statements": 80
      }
    }
  }
}
```

---

## Watch Mode During Development

```bash
npm test -- --watch
# Tests run automatically on file changes
```

## Pre-Commit Hook

```bash
# Runs before every commit
npm test && npm run lint
```

## CI/CD Integration

```yaml
# GitHub Actions
- name: Run Tests
  run: npm test -- --coverage
- name: Upload Coverage
  uses: codecov/codecov-action@v3
```
