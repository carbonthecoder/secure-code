# 🛡️ DOCTRINE 01: ZERO-TRUST APPLICATION SECURITY

> **Core Axiom**: Every boundary, request, parameter, header, and upstream service is hostile until validated, authenticated, authorized, and sanitized.

---

## 1. Input Boundary Validation & Schema Enforcement

### 1.1 Strict Schema First
Every gateway endpoint (REST, GraphQL, tRPC, gRPC, WebSockets) MUST validate all input parameters against a strongly typed schema before any processing occurs:
- **TypeScript**: Use `zod` with `.strict()` to reject unexpected fields (preventing mass assignment).
- **Python**: Use `pydantic.BaseModel` with `extra = "forbid"`.
- **Go**: Use struct validation tags or strongly typed unmarshaling.

### 1.2 Injection Elimination Matrix
| Attack Vector | Vulnerable Pattern | Hardened `secure-code` Invariant |
| :--- | :--- | :--- |
| **SQL Injection** | `SELECT * FROM users WHERE email = '${email}'` | Parameterized binding (`$1`, `?`, `:email`). |
| **Command Injection** | `exec("convert " + filename + " out.png")` | `spawn("convert", [filename, "out.png"])` with raw argument vectors. |
| **NoSQL Injection** | `db.users.find({ username: req.body.user })` where user is `{"$ne": null}` | Strict type assertion: input must be scalar string, never an object. |
| **Path Traversal** | `fs.readFileSync("/uploads/" + req.query.file)` | `const safePath = path.resolve(ROOT, path.normalize(file)); if (!safePath.startsWith(ROOT)) throw Error();` |

---

## 2. Broken Object-Level Authorization (IDOR) Defense

An Insecure Direct Object Reference (IDOR) occurs when code retrieves or mutates a record based solely on a client-supplied identifier without verifying tenancy or ownership.

### The Invariant Rule:
**Every database mutation or retrieval MUST explicitly include the authenticated tenant/user ID in the query filter.**

```typescript
// ❌ VULNERABLE (IDOR)
const doc = await db.document.findUnique({ where: { id: req.params.id } });
await db.document.update({ where: { id: req.params.id }, data: req.body });

// 🛡️ SECURE-CODE (Hardened Ownership Scoping)
const doc = await db.document.findFirst({
  where: {
    id: req.params.id,
    tenantId: session.user.tenantId, // Scoped to active organization/tenant
    userId: session.user.id          // Scoped to record owner
  }
});
if (!doc) throw new NotFoundError("Resource not found or unauthorized.");
```

---

## 3. Server-Side Request Forgery (SSRF) Defense

When an application fetches a user-supplied URL (e.g., webhook testing, profile avatar importer, metadata scraping):

1. **Protocol Restriction**: Only allow `http:` and `https:`. Explicitly disallow `file:`, `gopher:`, `ftp:`, `data:`.
2. **DNS Resolution & IP Validation**: Resolve the destination hostname to its IP address **before** issuing the request.
3. **Blacklist Private & Reserved Ranges**:
   - `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16` (RFC 1918)
   - `127.0.0.0/8` (Loopback)
   - `169.254.169.254` (Cloud Instance Metadata Service)
   - `::1`, `fc00::/7`, `fe80::/10` (IPv6 loopback & link-local)
4. **Disable Automatic Redirect Following**: Attackers bypass initial IP checks by redirecting from an external public domain to `http://169.254.169.254`. Always validate IPs on every redirect hop or disable redirects.

---

## 4. Authentication, Sessions & JWT Hardening

- **JWT Signing**: Use asymmetric algorithms (`RS256`, `Ed25519`) or HMAC with >= 256-bit entropy. Never accept `none` algorithm.
- **Short-Lived Access Tokens**: Access tokens expire in 15 minutes or less.
- **Refresh Token Rotation & Reuse Detection**: Refresh tokens are single-use. If a previously consumed refresh token is presented, invalidate all tokens in that family immediately (indicates token theft).
- **Cookie Security Configuration**:
  ```http
  Set-Cookie: session_id=...; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=86400
  ```

---

## 5. Security Headers Standard Suite

All production HTTP responses must include:
```http
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; object-src 'none'; base-uri 'self';
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
Permissions-Policy: camera=(), microphone=(), geolocation=()
```
