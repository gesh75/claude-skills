---
name: django-security
description: Django security best practices, authentication, authorization, CSRF protection, SQL injection prevention, XSS prevention, and secure deployment configurations.
origin: ECC
---

# Django Security Best Practices

Comprehensive security guidelines for Django applications to protect against common vulnerabilities.

## When to Activate

- Setting up Django authentication and authorization
- Implementing user permissions and roles
- Configuring production security settings
- Reviewing Django application for security issues
- Deploying Django applications to production

> For generic OWASP web-vulnerability background (what SQL injection, XSS, CSRF, broken access control are and why they matter), see the **security-review** skill. This skill covers only Django-specific mechanics and configuration.

## Core Security Settings (the essentials)

The single most important rule: `DEBUG = False` in production. Beyond that, force HTTPS, secure cookies, HSTS, strong password validators, and load `SECRET_KEY` from the environment.

```python
# settings/production.py — essential hardening (full version in reference/settings-hardening.md)
DEBUG = False  # CRITICAL: Never True in production
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_HSTS_SECONDS = 31536000          # 1 year
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'
SESSION_COOKIE_HTTPONLY = True
CSRF_COOKIE_HTTPONLY = True

SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY')
if not SECRET_KEY:
    raise ImproperlyConfigured('DJANGO_SECRET_KEY environment variable is required')
```

Full hardening (all headers, `AUTH_PASSWORD_VALIDATORS`, `PASSWORD_HASHERS` with Argon2, session config, CSP middleware, security logging) → [reference/settings-hardening.md](reference/settings-hardening.md).

## Authentication & Authorization

Django-specific building blocks:

- **Custom `User` model** (`AbstractUser`, `USERNAME_FIELD = 'email'`, `AUTH_USER_MODEL`).
- **Model permissions** via `Meta.permissions` + `LoginRequiredMixin`/`PermissionRequiredMixin` (`raise_exception = True` for 403).
- **DRF permission classes** (`IsOwnerOrReadOnly`, `IsAdminOrReadOnly`, `IsVerifiedUser`) using `has_object_permission`/`has_permission` and `SAFE_METHODS`.
- **RBAC** via a `role` field + role-checking methods/mixins.

Full code for all of the above → [reference/auth-authz.md](reference/auth-authz.md).

## Injection, XSS & CSRF (Django mechanics)

Django defends against these by default — the failures come from bypassing the defaults:

- **SQL injection**: use the ORM (`filter`, `Q`); never f-string into `.raw()` — always pass `%s` params.
- **XSS**: templates auto-escape; never `|safe` or `mark_safe()` raw user input — `escape()` first, or use `format_html()` / `|escapejs`.
- **CSRF**: enabled by default; keep `{% csrf_token %}` in forms and send `X-CSRFToken` on AJAX; only `@csrf_exempt` external webhooks.

Full examples (safe vs vulnerable) → [reference/injection-xss-csrf.md](reference/injection-xss-csrf.md).

## File Uploads, API Security & Secrets

- **File uploads**: validate extension and size via `FileField(validators=[...])`; don't serve user media from the app server (use S3/CDN).
- **API security**: DRF throttling (`DEFAULT_THROTTLE_RATES`), and authentication classes (Token/Session/JWT) with `IsAuthenticated` default.
- **Secrets**: load via `django-environ`/`python-decouple`; never commit `.env`.

Full code → [reference/uploads-api-secrets.md](reference/uploads-api-secrets.md).

## Quick Security Checklist

| Check | Description |
|-------|-------------|
| `DEBUG = False` | Never run with DEBUG in production |
| HTTPS only | Force SSL, secure cookies |
| Strong secrets | Use environment variables for SECRET_KEY |
| Password validation | Enable all password validators |
| CSRF protection | Enabled by default, don't disable |
| XSS prevention | Django auto-escapes, don't use `|safe` with user input |
| SQL injection | Use ORM, never concatenate strings in queries |
| File uploads | Validate file type and size |
| Rate limiting | Throttle API endpoints |
| Security headers | CSP, X-Frame-Options, HSTS |
| Logging | Log security events |
| Updates | Keep Django and dependencies updated |

Remember: Security is a process, not a product. Regularly review and update your security practices.

## Reference Files

- [reference/settings-hardening.md](reference/settings-hardening.md) — read when configuring production settings, password hashers/validators, sessions, security headers, CSP, or security logging.
- [reference/auth-authz.md](reference/auth-authz.md) — read when building a custom User model, model/DRF permissions, or RBAC.
- [reference/injection-xss-csrf.md](reference/injection-xss-csrf.md) — read when writing raw SQL, rendering user content in templates, or handling CSRF/AJAX/webhooks.
- [reference/uploads-api-secrets.md](reference/uploads-api-secrets.md) — read when handling file uploads, DRF throttling/auth, or managing secrets/env vars.
