---
name: django-verification
description: "Verification loop for Django projects: migrations, linting, tests with coverage, security scans, and deployment readiness checks before release or PR."
origin: ECC
---

# Django Verification Loop

Run before PRs, after major changes, and pre-deploy to ensure Django application quality and security.

This is the Django-specific instance of the generic verify-before-ship gate. For the general gate philosophy (RED→GREEN ordering, when to stop, how to sequence gates), see the **verification-loop** skill. This skill covers only the Django-specific command flow and what each phase reports.

## When to Activate

- Before opening a pull request for a Django project
- After major model changes, migration updates, or dependency upgrades
- Pre-deployment verification for staging or production
- Running full environment → lint → test → security → deploy readiness pipeline
- Validating migration safety and test coverage

## Verification Phase Flow

Run phases in order; stop and fix before continuing if a phase fails.

| # | Phase | What it does | Key command(s) |
|---|-------|--------------|----------------|
| 1 | Environment Check | Python version, venv, required env vars (e.g. `DJANGO_SECRET_KEY`) | `python --version` · `pip list --outdated` |
| 2 | Code Quality | Type check, lint, format, import sort, Django deploy check | `mypy .` · `ruff check . --fix` · `black .` · `isort .` · `python manage.py check --deploy` |
| 3 | Migrations | Detect unapplied/missing migrations and conflicts | `python manage.py makemigrations --check` · `migrate --plan` |
| 4 | Tests + Coverage | pytest with coverage, per-app breakdown | `pytest --cov=apps --cov-report=term-missing --reuse-db` |
| 5 | Security Scan | Dependency CVEs, Django deploy checks, bandit, secret scan | `pip-audit` · `safety check` · `bandit -r .` · `gitleaks detect` |
| 6 | Django Commands | `check`, `collectstatic`, DB integrity, cache reachability | `python manage.py collectstatic --noinput --clear` |
| 7 | Performance | N+1 query / missing-index / duplicate-query detection | Debug Toolbar · `debugsqlshell` |
| 8 | Static Assets | `npm audit`, asset build, `findstatic` | `npm audit` · `python manage.py findstatic` |
| 9 | Configuration Review | DEBUG=False, SECRET_KEY, ALLOWED_HOSTS, HTTPS/HSTS, non-sqlite DB | shell settings check |
| 10 | Logging | Verify logger output and log file writability | shell logging test |
| 11 | API Documentation (DRF) | Generate + validate OpenAPI schema | `python manage.py generateschema` |
| 12 | Diff Review | Stats + grep for debug statements, secrets, missing migrations | `git diff --stat` · `git diff \| grep ...` |

Full copy-paste command transcripts for every phase, the report output template, and the GitHub Actions CI workflow live in [reference/command-transcripts.md](reference/command-transcripts.md).

### Notes per area (Django-specific)

- **Migrations (Phase 3):** this loop only *detects* migration state. For writing safe Django migrations (data backfills, `SeparateDatabaseAndState`, zero-downtime) see the **database-migrations** skill.
- **Security (Phase 5):** for Django security configuration patterns themselves (auth, CSRF, SQLi/XSS prevention, secure settings), see the **django-security** skill. Here we only run the scanners.
- **Tests (Phase 4):** for writing the tests and reaching coverage (pytest-django, factory_boy, DRF API tests), see the **django-tdd** skill.

## Coverage Targets

| Component | Target |
|-----------|--------|
| Models | 90%+ |
| Serializers | 85%+ |
| Views | 80%+ |
| Services | 90%+ |
| Overall | 80%+ |

## Pre-Deployment Checklist

- [ ] All tests passing
- [ ] Coverage ≥ 80%
- [ ] No security vulnerabilities
- [ ] No unapplied migrations
- [ ] DEBUG = False in production settings
- [ ] SECRET_KEY properly configured
- [ ] ALLOWED_HOSTS set correctly
- [ ] Database backups enabled
- [ ] Static files collected and served
- [ ] Logging configured and working
- [ ] Error monitoring (Sentry, etc.) configured
- [ ] CDN configured (if applicable)
- [ ] Redis/cache backend configured
- [ ] Celery workers running (if applicable)
- [ ] HTTPS/SSL configured
- [ ] Environment variables documented

## Quick Reference

| Check | Command |
|-------|---------|
| Environment | `python --version` |
| Type checking | `mypy .` |
| Linting | `ruff check .` |
| Formatting | `black . --check` |
| Migrations | `python manage.py makemigrations --check` |
| Tests | `pytest --cov=apps` |
| Security | `pip-audit && bandit -r .` |
| Django check | `python manage.py check --deploy` |
| Collectstatic | `python manage.py collectstatic --noinput` |
| Diff stats | `git diff --stat` |

Remember: Automated verification catches common issues but doesn't replace manual code review and testing in staging environment.

## Reference Files

- [reference/command-transcripts.md](reference/command-transcripts.md) — read when running a specific phase; full per-phase command transcripts, the verification report output template, and the GitHub Actions CI workflow.
