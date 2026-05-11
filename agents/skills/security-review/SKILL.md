---
name: security-review
description: "Perform a security audit of a codebase identifying vulnerabilities, anti-patterns, and remediation steps. Use when: security review, security audit, finding vulnerabilities, checking for injection risks, reviewing authentication, OWASP review."
argument-hint: "File, folder, or component to audit (optional, defaults to entire codebase)"
---

# Security Review

## When to Use

- Auditing a codebase for security vulnerabilities
- Reviewing authentication and authorization logic
- Checking for injection risks (SQL, XSS, command injection)
- Assessing input validation and error handling
- Preparing for a security compliance review

## Procedure

### Step 1: Gather Context

- Identify the application type (web app, API, CLI, library)
- Understand the authentication/authorization model
- Map external inputs (user input, API parameters, file uploads, environment variables)
- Identify data stores and sensitive data flows

### Step 2: Input Validation & Injection

Check all external input entry points:

1. **SQL/NoSQL injection** — Are queries parameterized? Is user input ever interpolated into queries?
2. **XSS (Cross-Site Scripting)** — Is output encoded/escaped? Are raw HTML insertions sanitized?
3. **Command injection** — Is user input passed to shell commands or exec calls?
4. **Path traversal** — Are file paths validated against directory escape (../, %2e%2e)?
5. **Deserialization** — Are untrusted inputs deserialized without validation?

### Step 3: Authentication & Authorization

Review access control:

1. **Authentication** — Are credentials stored securely (hashed, salted)? Are sessions managed properly?
2. **Authorization** — Are permissions checked on every protected resource? Are there broken access control paths?
3. **Token management** — Are tokens short-lived? Are refresh flows secure? Are JWTs validated properly?
4. **Secrets** — Are API keys, passwords, or tokens hardcoded or committed to source control?

### Step 4: Error Handling & Information Disclosure

1. **Error messages** — Do error responses leak stack traces, internal paths, or database details?
2. **Logging** — Are sensitive values (passwords, tokens, PII) logged?
3. **Debug modes** — Are debug endpoints or verbose modes disabled in production?

### Step 5: Configuration & Infrastructure

1. **HTTPS** — Is TLS enforced? Are there mixed-content issues?
2. **CORS** — Are origins restricted appropriately?
3. **Headers** — Are security headers set (CSP, X-Frame-Options, HSTS)?
4. **Dependencies** — Are there known CVEs in current dependencies? (Cross-reference with `dependency-analysis` skill)

### Step 6: Business Logic

1. **Race conditions** — Are there TOCTOU vulnerabilities or unprotected concurrent operations?
2. **Rate limiting** — Are brute-force attacks mitigated?
3. **Privilege escalation** — Can a user manipulate requests to gain elevated access?

### Step 7: Produce the Report

Output findings organized by severity.

## Output Format

### Critical

| #   | Vulnerability | Location    | Impact                    | Remediation  |
| --- | ------------- | ----------- | ------------------------- | ------------ |
| 1   | Description   | `file:line` | What an attacker could do | Specific fix |

### High

| #   | Vulnerability | Location | Impact | Remediation |
| --- | ------------- | -------- | ------ | ----------- |

### Medium

| #   | Vulnerability | Location | Impact | Remediation |
| --- | ------------- | -------- | ------ | ----------- |

### Low / Informational

| #   | Finding | Location | Recommendation |
| --- | ------- | -------- | -------------- |

### Summary

- Total findings: X (Critical: N, High: N, Medium: N, Low: N)
- Most affected areas: list
- Recommended priority actions: top 3

## Constraints

**Required (always apply, in order of precedence):**

1. Classify every finding by severity (Critical / High / Medium / Low)
2. Always provide specific file paths and line numbers — never give generic warnings
3. Include a concrete remediation step for every finding
4. Never disclose or suggest exploit code

**Quality (apply after required constraints are met):**

5. Reference OWASP Top 10 categories where applicable
6. Only flag vulnerabilities that are exploitable given the project's actual deployment context — do not flag issues that require unrealistic preconditions (e.g., direct database access by an unauthenticated external attacker when the database is not externally exposed, or physical server access)
