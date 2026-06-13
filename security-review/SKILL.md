---
name: security-review
description: Use this skill when adding authentication, handling user input, working with secrets, creating API endpoints, or implementing payment/sensitive features. Provides comprehensive security checklist and patterns.
origin: ECC
---

# Security Review Skill

This skill ensures all code follows security best practices and identifies potential vulnerabilities.

## When to Activate

- Implementing authentication or authorization
- Handling user input or file uploads
- Creating new API endpoints
- Working with secrets or credentials
- Implementing payment features
- Storing or transmitting sensitive data
- Integrating third-party APIs

## Security Checklist

Work through each area below. Each links to full FAIL/PASS code patterns in the reference files — read the relevant reference when you need the implementation, not just the checklist.

### 1. Secrets Management
Code: `language-checklists.md` §1

- [ ] No hardcoded API keys, tokens, or passwords
- [ ] All secrets in environment variables
- [ ] `.env.local` in .gitignore
- [ ] No secrets in git history
- [ ] Production secrets in hosting platform (Vercel, Railway)

### 2. Input Validation
Code: `language-checklists.md` §2 (Zod schemas, file upload validation)

- [ ] All user inputs validated with schemas
- [ ] File uploads restricted (size, type, extension)
- [ ] No direct use of user input in queries
- [ ] Whitelist validation (not blacklist)
- [ ] Error messages don't leak sensitive info

### 3. SQL Injection Prevention
Code: `language-checklists.md` §3 (parameterized queries)

- [ ] All database queries use parameterized queries
- [ ] No string concatenation in SQL
- [ ] ORM/query builder used correctly
- [ ] Supabase queries properly sanitized

### 4. Authentication & Authorization
Code: `language-checklists.md` §4 (JWT/httpOnly cookies, auth checks, Supabase RLS)

- [ ] Tokens stored in httpOnly cookies (not localStorage)
- [ ] Authorization checks before sensitive operations
- [ ] Row Level Security enabled in Supabase
- [ ] Role-based access control implemented
- [ ] Session management secure

### 5. XSS Prevention
Code: `language-checklists.md` §5 (DOMPurify, CSP headers)

- [ ] User-provided HTML sanitized
- [ ] CSP headers configured
- [ ] No unvalidated dynamic content rendering
- [ ] React's built-in XSS protection used

### 6. CSRF Protection
Code: `language-checklists.md` §6 (CSRF tokens, SameSite cookies)

- [ ] CSRF tokens on state-changing operations
- [ ] SameSite=Strict on all cookies
- [ ] Double-submit cookie pattern implemented

### 7. Rate Limiting
Code: `language-checklists.md` §7 (express-rate-limit)

- [ ] Rate limiting on all API endpoints
- [ ] Stricter limits on expensive operations
- [ ] IP-based rate limiting
- [ ] User-based rate limiting (authenticated)

### 8. Sensitive Data Exposure
Code: `language-checklists.md` §8 (logging redaction, generic error messages)

- [ ] No passwords, tokens, or secrets in logs
- [ ] Error messages generic for users
- [ ] Detailed errors only in server logs
- [ ] No stack traces exposed to users

### 9. Blockchain & Payment Security
Code: `payments-crypto.md` (wallet + transaction verification)

- [ ] Wallet signatures verified
- [ ] Transaction details validated
- [ ] Balance checks before transactions
- [ ] No blind transaction signing

### 10. Dependency Security
Code: `language-checklists.md` §10 (npm audit, lock files)

- [ ] Dependencies up to date
- [ ] No known vulnerabilities (npm audit clean)
- [ ] Lock files committed
- [ ] Dependabot enabled on GitHub
- [ ] Regular security updates

### 11. Cloud & Infrastructure
Code: `cloud-infrastructure-security.md`

- [ ] IAM least-privilege, no wildcard policies
- [ ] Storage buckets private by default
- [ ] Secrets in a managed secret store, not env files in images
- [ ] Network segmentation and security groups locked down

### 12. API Security (REST & GraphQL)

Object-level & access control:
- [ ] IDOR/BOLA: user A cannot access user B's resources — test explicitly on every nested resource
- [ ] Broken object-level authorization checked on each endpoint, not just the parent
- [ ] Mass assignment blocked — reject bulk-updating sensitive fields (e.g. `role`, `isAdmin`)
- [ ] RBAC checks *what* (resource + action), not just *who* (identity)
- [ ] Never trust client-supplied roles or permissions

Token & auth specifics:
- [ ] JWT: validate signature, expiry (`exp`), issuer (`iss`), and audience (`aud`) on every request
- [ ] OAuth 2.0 with PKCE for user-facing flows; client credentials for service-to-service
- [ ] API keys hashed before storage, scoped to minimum permissions, rotated on breach

GraphQL-specific:
- [ ] Query depth limiting enabled
- [ ] Query cost / complexity analysis enforced
- [ ] Introspection disabled in production

Identifiers & transport:
- [ ] UUIDs or opaque tokens as resource IDs — never sequential IDs in responses
- [ ] Security headers set: HSTS, `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, CSP
- [ ] CORS whitelists specific origins — never `Access-Control-Allow-Origin: *` for authenticated APIs

## Security Testing

Automated test patterns (auth required, role checks, input validation rejection, rate-limit enforcement) are in `language-checklists.md` → "Security Testing".

## Pre-Deployment Security Checklist

Before ANY production deployment:

- [ ] **Secrets**: No hardcoded secrets, all in env vars
- [ ] **Input Validation**: All user inputs validated
- [ ] **SQL Injection**: All queries parameterized
- [ ] **XSS**: User content sanitized
- [ ] **CSRF**: Protection enabled
- [ ] **Authentication**: Proper token handling
- [ ] **Authorization**: Role checks in place
- [ ] **Rate Limiting**: Enabled on all endpoints
- [ ] **HTTPS**: Enforced in production
- [ ] **Security Headers**: CSP, X-Frame-Options configured
- [ ] **Error Handling**: No sensitive data in errors
- [ ] **Logging**: No sensitive data logged
- [ ] **Dependencies**: Up to date, no vulnerabilities
- [ ] **Row Level Security**: Enabled in Supabase
- [ ] **CORS**: Properly configured
- [ ] **File Uploads**: Validated (size, type)
- [ ] **Wallet Signatures**: Verified (if blockchain)
- [ ] **IDOR/BOLA**: Object-level authorization tested per resource
- [ ] **Mass Assignment**: Sensitive fields not bulk-updatable
- [ ] **GraphQL**: Depth/cost limits set, introspection off in prod (if GraphQL)

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Next.js Security](https://nextjs.org/docs/security)
- [Supabase Security](https://supabase.com/docs/guides/auth)
- [Web Security Academy](https://portswigger.net/web-security)

---

## Reference Files

- **language-checklists.md** — read when you need the FAIL/PASS code for web/TypeScript vulns (secrets, input validation, SQLi, auth, XSS, CSRF, rate limiting, data exposure, dependencies) plus security test patterns.
- **payments-crypto.md** — read when implementing blockchain (Solana) or sensitive payment features: wallet ownership + transaction verification.
- **cloud-infrastructure-security.md** — read when reviewing cloud/IaC, IAM, storage buckets, secret stores, and network configuration.

---

**Remember**: Security is not optional. One vulnerability can compromise the entire platform. When in doubt, err on the side of caution.
