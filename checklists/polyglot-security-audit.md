# 🛡️ 60-POINT POLYGLOT DEVSECOPS SECURITY AUDIT

Use this checklist before releasing code to production or merging AI-generated pull requests.

## I. Input Validation & Injection (10 Points)
- [ ] 01. All SQL/NoSQL queries use parameterized statements; no raw string interpolation exists.
- [ ] 02. No user inputs are passed to system shells (`exec`, `system`, `sh -c`).
- [ ] 03. All HTTP request bodies and queries are validated with strict typed schemas (Zod, Pydantic, etc.).
- [ ] 04. Object schemas disallow unrecognized extra keys (`.strict()` or `extra="forbid"`).
- [ ] 05. File upload paths are resolved and asserted to stay within target root directories (anti-path traversal).
- [ ] 06. Archive (ZIP/TAR) extractions check entry paths against Zip Slip vulnerabilities.
- [ ] 07. User strings rendered into HTML are escaped by default; raw HTML injectors are banned.
- [ ] 08. User-supplied URLs undergo SSRF validation: private/loopback CIDRs and metadata IP are blocked.
- [ ] 09. URL redirect endpoints validate against an explicit whitelist of allowed domains.
- [ ] 10. XML parsers explicitly disable external entities (anti-XXE).

## II. Tenancy, Auth & IDOR (10 Points)
- [ ] 11. Every database mutation (`UPDATE`, `DELETE`) includes a `tenant_id` and/or `user_id` check.
- [ ] 12. Every database query (`SELECT`) scopes read access to the authenticated user's organization.
- [ ] 13. Passwords are encrypted using Argon2id or bcrypt (cost >= 12).
- [ ] 14. Password reset tokens are single-use, hashed in database, and expire in <= 15 minutes.
- [ ] 15. Cryptographic tokens, webhooks, and HMACs use constant-time comparison algorithms.
- [ ] 16. Random tokens are generated via CSPRNG (`crypto.randomBytes`, `secrets`).
- [ ] 17. Authentication cookies use `HttpOnly; Secure; SameSite=Strict`.
- [ ] 18. Session fixation defense: session IDs regenerate upon login and privilege escalation.
- [ ] 19. Brute-force rate limiting is enforced on login, registration, and password reset endpoints.
- [ ] 20. JWT tokens have short expiration (<= 15m), and refresh tokens use rotation with reuse detection.

## III. Network, Headers & Transport (10 Points)
- [ ] 21. `Strict-Transport-Security` (HSTS) header is enabled with `includeSubDomains; preload`.
- [ ] 22. `Content-Security-Policy` (CSP) header is configured without `'unsafe-inline'`.
- [ ] 23. `X-Content-Type-Options: nosniff` header is present on all responses.
- [ ] 24. `X-Frame-Options: DENY` is set to block clickjacking.
- [ ] 25. CORS origin header validates against an explicit whitelist; never `*` with credentials.
- [ ] 26. WebSocket upgrade requests validate the `Origin` header (anti-CSWSH).
- [ ] 27. Server-Sent Events (SSE) close gracefully on client disconnect without leaking memory.
- [ ] 28. TLS 1.2 or 1.3 is enforced on all incoming connections; insecure ciphers are disabled.
- [ ] 29. Reverse proxies (Nginx/Cloudflare) strip internal debugging headers from client requests.
- [ ] 30. Error responses never leak stack traces, database schema details, or server version headers.

## IV. Cryptography & Data Protection (10 Points)
- [ ] 31. Zero secrets or API keys are hardcoded in source files or git history.
- [ ] 32. Environment variables are validated on server boot, failing fast if any required key is missing.
- [ ] 33. Sensitive fields in database (PII, SSN, bank numbers) are encrypted at rest using AES-256-GCM.
- [ ] 34. Cryptographic initialization vectors (IVs) and salts are unique per encryption operation.
- [ ] 35. Financial values use integer cents or Decimal types; zero floating point math used for money.
- [ ] 36. Usernames and identifiers undergo Unicode normalization (NFKC) before hashing and querying.
- [ ] 37. Application logs sanitize PII, passwords, credit card numbers, and auth headers.
- [ ] 38. Mobile applications store sensitive tokens only in Keystore (Android) or Keychain (iOS).
- [ ] 39. Mobile apps enforce SSL/TLS pinning for high-security endpoints.
- [ ] 40. Database backups are encrypted with audited key rotation schedules.

## V. Concurrency & Logic Integrity (10 Points)
- [ ] 41. Inventory decrements and balance deductions use atomic database updates or optimistic locking.
- [ ] 42. Webhooks implement idempotency keys to prevent duplicate transaction execution.
- [ ] 43. Multi-threaded shared state is guarded by mutexes or atomic primitives.
- [ ] 44. Go tests run with `-race` enabled; no data races exist in shared memory.
- [ ] 45. Rust code forbids unverified `unsafe` blocks; production code avoids raw `.unwrap()`.
- [ ] 46. Database transactions never encapsulate slow external network calls (anti-connection starvation).
- [ ] 47. Database connection pools are bounded to hardware limits and handle error release.
- [ ] 48. Cache stampedes on hot keys are mitigated with XFetch or distributed mutexes.
- [ ] 49. File decompression streams enforce total byte quotas to prevent Zip Bomb attacks.
- [ ] 50. Image uploads are dimension-checked before decoding to block Pixel Flood memory bombs.

## VI. Supply Chain & Agentic Security (10 Points)
- [ ] 51. Dependencies are locked via lockfiles (`package-lock.json`, `poetry.lock`, `Cargo.lock`).
- [ ] 52. Automated dependency vulnerability scanning (`npm audit`, `snyk`, `cargo audit`) passes clean.
- [ ] 53. CI/CD pipelines run in unprivileged containers with minimal access tokens.
- [ ] 54. External scripts on web pages include Subresource Integrity (`integrity="sha384-..."`).
- [ ] 55. AI agent tools are restricted to least-privilege whitelisted actions.
- [ ] 56. External untrusted text parsed by AI agents is demarcated with boundary delimiters.
- [ ] 57. Destructive actions (drop table, rm -rf, git force) require human confirmation.
- [ ] 58. Autonomous AI agent turn horizon is hard-capped (<= 15 steps per task).
- [ ] 59. Markdown renderers strip external image URLs that could exfiltrate tokens.
- [ ] 60. External links with `target="_blank"` include `rel="noopener noreferrer"`.
