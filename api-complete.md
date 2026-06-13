---
name: api-complete
description: "Composite super-skill: complete API development lifecycle combining design principles, security hardening, testing strategy, and documentation generation. Use when designing, auditing, or building out a full API."
risk: safe
---

# API Complete

A full-lifecycle API composite combining `api-design`, `api-security-best-practices`, `api-testing-strategy`, and `api-documentation-guide`.

## When to Use

- Designing a new API from scratch
- Auditing an existing API for quality, security, or consistency
- Preparing an API for external/public consumption
- Adding a new service to an existing API ecosystem

## Phase 1: Design

Use the **`api-design`** skill for the full REST conventions — resource naming, URL structure, HTTP methods/status codes, response envelopes, versioning, pagination, filtering, and rate limiting. Don't duplicate them here; apply that skill first.

Then run this composite-specific **design checklist** before moving on:
- [ ] Consistent naming (snake_case or camelCase — pick one)
- [ ] Idempotent PUT and DELETE
- [ ] PATCH for partial updates, not PUT
- [ ] Error responses include `code`, `message`, and `field` where applicable
- [ ] Timestamps in ISO 8601 (UTC)
- [ ] IDs are strings (not sequential integers for security)

## Phase 2: Security Hardening (from `api-security-best-practices`)

**Authentication & Authorization:**
- Use OAuth 2.0 / JWT for stateless auth — never session cookies for APIs
- Validate JWT signature, expiry, issuer, and audience on every request
- Implement RBAC: check *what* the user can do, not just *who* they are
- Scope tokens to minimum required permissions

**Input validation:**
- Validate all inputs server-side — never trust client
- Use a schema validation library (Zod, Joi, Pydantic, etc.)
- Whitelist allowed fields — reject unknown properties
- Enforce max lengths on all string fields
- Sanitize before storing or returning

**Injection prevention:**
- Use parameterized queries — never string concatenation for SQL
- Escape all user data before templating into HTML/shell/regex
- Validate Content-Type headers

**Rate limiting:**
- Implement per-IP and per-user rate limits
- Return `Retry-After` header on 429 responses
- Apply stricter limits on auth endpoints (login, password reset)

**Transport security:**
- HTTPS only — redirect HTTP to HTTPS
- HSTS header: `Strict-Transport-Security: max-age=31536000; includeSubDomains`
- Set `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`
- CORS: whitelist specific origins — never `Access-Control-Allow-Origin: *` for authenticated APIs

**Sensitive data:**
- Never return passwords, secrets, or internal IDs in responses
- Mask/truncate sensitive fields (card numbers, SSNs)
- Don't log request bodies containing sensitive data

## Phase 3: Testing Strategy (from `api-testing-strategy`)

**Test pyramid for APIs:**

```
          E2E (few)
        Integration (many)
      Contract tests (per consumer)
    Unit tests (most)
```

**Unit tests:**
- Test request validation logic
- Test business logic independent of HTTP layer
- Test error handling paths
- Mock external dependencies

**Integration tests:**
- Test each endpoint with real DB (use test containers)
- Test happy path + all error codes
- Test auth enforcement — unauthenticated and unauthorized requests
- Test pagination edge cases (empty, single item, last page)

**Contract tests:**
- Use OpenAPI spec as the contract
- Validate all responses against the spec in CI
- Run consumer-driven contract tests (Pact) for microservices

**Security tests:**
- Test that auth is enforced on every protected endpoint
- Test IDOR: can user A access user B's resources?
- Test rate limiting triggers correctly
- Fuzz input fields with boundary values and malformed data

**Performance tests:**
- Baseline response times for each endpoint
- Load test to find breaking point before production
- Identify N+1 query patterns under load

## Phase 4: Documentation (from `api-documentation-guide`)

**OpenAPI spec first:**
- Write or generate `openapi.yaml` — this becomes the source of truth
- Every endpoint: summary, description, parameters, request body, all response codes
- Include examples for request and response bodies

**Endpoint documentation template:**
```yaml
/users/{id}:
  get:
    summary: Get user by ID
    description: Returns a single user. Returns 404 if not found.
    parameters:
      - name: id
        in: path
        required: true
        schema: { type: string }
    responses:
      200:
        description: User found
        content:
          application/json:
            example: { "data": { "id": "usr_123", "name": "Alice" } }
      404:
        description: User not found
```

**Developer guide (beyond the spec):**
- Authentication walkthrough with working code example
- Quick start: "make your first API call in 5 minutes"
- Common error codes and how to handle them
- Rate limit headers and how to respect them
- Changelog and deprecation policy

**Auto-generate where possible:**
- Use Swagger UI or Redoc for interactive docs from OpenAPI spec
- Generate SDK clients from the spec (openapi-generator)
- Keep docs in sync with code via CI validation

## Output

Deliver:
1. Resource model and URL structure
2. OpenAPI spec (or annotated endpoint list)
3. Security checklist — checked or flagged
4. Test plan with coverage targets
5. Documentation outline or generated docs
