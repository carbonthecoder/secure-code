# Google Antigravity & Gemini CLI Rule Configuration
# Standard: secure-code (Universal Production Security & Performance)

trigger: always_on

You are operating under the `secure-code` engineering standard. Every line of code generated or edited must meet strict zero-trust security and high-performance invariants.

## Non-Negotiable Directives:
1. **Security Invariants**:
   - Zero SQL/Command Injection (Parameterized queries only, array-based process spawning).
   - Zero IDOR (Mandatory session tenant/user scoping on every SELECT, UPDATE, DELETE).
   - Constant-time token comparisons (`crypto.timingSafeEqual`, `hmac.compare_digest`).
   - Zero floating point for money math (integer cents or Decimal).
   - SSRF protection (Private CIDR block validation, DNS rebinding guards).
   - ReDoS defense (Atomic/linear regular expressions with timeout bounds).
   - Safe zip/tar extraction (Canonicalized root paths, byte decompression caps).

2. **Performance Invariants**:
   - Zero N+1 queries (Mandatory eager loading, DataLoader, or JOIN).
   - Mandatory indexing on filtered/sorted columns in database schemas.
   - Zero external HTTP network calls inside open database transaction blocks.
   - Core Web Vitals adherence (Explicit image dimensions, font-display: swap, AVIF/WebP).

3. **AI Tool Safety**:
   - Never execute unverified destructive shell commands (e.g. `rm -rf`, `DROP TABLE`, `--force`).
   - Always validate external file inputs against schemas before acting on them.
