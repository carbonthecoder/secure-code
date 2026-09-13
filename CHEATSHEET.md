# ⚡ `secure-code` 1-PAGE PRODUCTION CHEAT SHEET

> **The Quick-Lookup Engineering Reference for DevSecOps, SREs & AI Prompts.**
> Keep this open when building, reviewing PRs, or prompting AI coding assistants.

---

## 1. Top Invariant Cheat Sheet (Quick Reference Table)

| Domain | ❌ Never Do This (Vulnerable / Slow) | 🛡️ Always Do This (`secure-code` Invariant) |
| :--- | :--- | :--- |
| **SQL Queries** | `"WHERE id = '" + id + "'"` | Parameterized placeholder (`$1`, `?`, `:id`) |
| **Data Ownership** | `db.find({ id })` | `db.find({ id, tenantId, userId })` **(Zero IDOR)** |
| **Token Equality** | `if (token === expected)` | `crypto.timingSafeEqual()` / `hmac.compare_digest()` |
| **Money / Currency** | `let total = price * 0.08` | Integer minor units (`cents = 1999n`) or `Decimal` |
| **Random Tokens** | `Math.random().toString(36)` | CSPRNG: `crypto.randomBytes(32)` / `secrets.token_hex()` |
| **External URLs** | `fetch(userSuppliedUrl)` | Pre-resolve DNS, block private CIDRs & 169.254.169.254 |
| **DB Transactions** | `await tx.run(); await stripe.pay();` | **No network calls in DB transactions** (Externalize!) |
| **Relational Data** | `for (u of users) await getProfile(u)` | Eager fetch / batching / DataLoader **(Zero N+1)** |
| **Password Hashing**| MD5, SHA-256, or plain bcrypt cost 8 | Argon2id (t=2, m=19MB, p=1) or bcrypt cost >= 12 |
| **Web Vitals** | `<img>` without dimensions, unhosted fonts | Explicit `width`/`height`, `font-display: swap`, AVIF |

---

## 2. Micro-Code Snippets for Instant Copy-Paste

### A. Constant-Time Signature & Token Comparison
```typescript
// Node.js
import crypto from "crypto";
function safeCompare(a: string, b: string): boolean {
  const bufA = Buffer.from(a, "utf8");
  const bufB = Buffer.from(b, "utf8");
  return bufA.length === bufB.length && crypto.timingSafeEqual(bufA, bufB);
}
```
```python
# Python
import hmac
is_valid = hmac.compare_digest(user_token, secret_token)
```

---

### B. Zero-Loss Currency & Tax Math (Banker's Rounding)
```typescript
// Calculate 8.25% tax on $19.99 with integer cents
const priceInCents = 1999n;
const taxRateBasisPoints = 825n; // 8.25% in basis points (1/10000)
const taxInCents = (priceInCents * taxRateBasisPoints + 5000n) / 10000n; // Half-up rounding
const totalInCents = priceInCents + taxInCents; // $21.64
```

---

### C. Safe Path Traversal Resolution
```typescript
import path from "path";
function getSafeFilePath(baseDir: string, userFile: string): string {
  const resolved = path.resolve(baseDir, path.normalize(userFile));
  if (!resolved.startsWith(baseDir + path.sep)) {
    throw new Error("Access Denied: Path traversal detected");
  }
  return resolved;
}
```

---

### D. Private CIDRs to Block for SSRF Defense
```text
IPv4 Blocklist:
├── 127.0.0.0/8       (Loopback)
├── 10.0.0.0/8        (Private RFC 1918)
├── 172.16.0.0/12     (Private RFC 1918)
├── 192.168.0.0/16    (Private RFC 1918)
├── 169.254.0.0/16    (Link-Local & Cloud Metadata 169.254.169.254)
└── 0.0.0.0/8         (Broadcast)

IPv6 Blocklist:
├── ::1/128           (Loopback)
├── fc00::/7          (Unique Local Address)
└── fe80::/10         (Link-Local)
```

---

### E. Standard Production Security Headers (Copy into Reverse Proxy)
```http
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data: https:; object-src 'none'; frame-ancestors 'none';
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

---

## 3. Language-Specific Pitfall Watchlist

| Language | The Trap AI Assistants Generate | The Hardened Invariant |
| :--- | :--- | :--- |
| **Python** | Synchronous blocking I/O inside `async def` | Wrap in `asyncio.to_thread()` or use async drivers (`asyncpg`) |
| **Python** | `pickle.loads()` on untrusted payloads | Ban pickle; use `json` or Pydantic v2 schemas |
| **Go** | Concurrently reading/writing shared map | Guard with `sync.RWMutex` or `sync.Map`; test with `-race` |
| **Go** | Unbuffered channels leaking goroutines | Manage lifetimes with `context.WithTimeout()` |
| **Rust** | `.unwrap()` panicking in production routes | Use `?` operator with custom typed `Result<T, AppError>` |
| **Rust** | Long CPU work starving Tokio async runtime | Move to `tokio::task::spawn_blocking` |
| **Node.js**| Synchronous heavy crypto/JSON on event loop | Offload to `worker_threads` |
| **C# .NET**| `.Result` or `.Wait()` on asynchronous Tasks | Always `await` tasks end-to-end (avoid sync-over-async) |
| **Java** | JPA `FetchType.EAGER` causing N+1 queries | Use `FetchType.LAZY` with `@EntityGraph` or `JOIN FETCH` |
| **PHP** | Loose equality type juggling (`"0e1" == "0"`) | `declare(strict_types=1);` and `===` everywhere |

---

## 4. Latency & Core Web Vitals Target Card

```
[ FRONTEND VITALS ]
├── Largest Contentful Paint (LCP)  < 1.2s  (fetchpriority="high", preloaded hero)
├── Interaction to Next Paint (INP) < 100ms (Tasks <= 50ms, scheduler.yield())
└── Cumulative Layout Shift (CLS)   < 0.05  (Explicit aspect-ratio / width / height)

[ BACKEND BUDGETS ]
├── In-Memory L1 Cache Hit          < 0.5ms (In-process LRU cache)
├── Redis L2 Cache Hit              < 2.0ms (Pipelined commands)
├── Database P95 Query Latency      < 15.0ms (Indexed, no seq scans)
└── Edge TTFB                       < 80.0ms (HTTP/3, TLS 1.3, Brotli br level 11)
```
