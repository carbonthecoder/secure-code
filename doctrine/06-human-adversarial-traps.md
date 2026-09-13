# 🧠 DOCTRINE 06: HUMAN ADVERSARIAL TRAPS & DISTRIBUTED STATE

> **Core Axiom**: AI models optimize for syntactical correctness and local problem resolution. They cannot intuitively understand time, distributed concurrency, supply-chain poisoning, or the human tendency for temporary mock code to accidentally ship to production.

---

## 1. AI Package Hallucination Defense (Slopsquatting)

### The Threat
LLMs routinely hallucinate non-existent package names when prompted for specialized utilities (e.g. `npm i safe-jwt-validator` or `pip install fastapi-rate-limit-redis`). Malicious actors monitor common LLM hallucination frequencies, register those exact package names on public package registries (npm/PyPI), and embed automated malicious install scripts (`postinstall`).

### The Invariant Rule:
**Strict Zero-Unvetted Dependency Policy.**
1. AI assistants must **never** recommend, import, or introduce third-party packages not already declared in the project's lockfile (`package-lock.json`, `poetry.lock`, `Cargo.lock`).
2. Always prefer native standard library modules (`crypto`, `http`, `urllib`, `secrets`, `sync`) before reaching for third-party packages.
3. If a new dependency is strictly necessary, it must be an established Tier-1 library with over 1,000,000 weekly downloads or verified official framework maintenance.

---

## 2. The "Mock Security Fallback" Prohibition (Fail-Closed)

### The Threat
When generating example routes, AI assistants frequently emit temporary mock fallbacks:
```typescript
// ❌ VULNERABLE (AI Prototype Shortcut that accidentally ships)
const userId = req.headers["x-user-id"] || "admin-user-id";
const role = req.query.role || "USER"; // TODO: Add real session check
```
In real engineering teams, deadlines cause temporary mock code to get merged into production. Attackers scan public endpoints and GitHub commits specifically looking for `// TODO: add auth` or arbitrary header trust.

### The Invariant Rule:
**All security boundaries MUST fail-closed.**
- NEVER fall back to hardcoded mock user IDs, admin privileges, or placeholder session tokens.
- If an authentication credential or session context is missing or unverified, throw an unhandled `UnauthorizedException` (HTTP 401) immediately.

---

## 3. Atomic Concurrency & The Double-Spend Bug

### The Threat
AI models check state in application memory, failing to recognize that concurrent requests can read identical state simultaneously before a write completes:
```typescript
// ❌ VULNERABLE (Double-Spend Race Condition)
const account = await db.account.findUnique({ where: { id: accountId } });
if (account.balance >= withdrawAmount) {
  // Attacker fires 20 concurrent requests at the exact same millisecond.
  // All 20 read balance = $100.
  await db.account.update({
    where: { id: accountId },
    data: { balance: account.balance - withdrawAmount }
  });
}
```

### The Invariant Rule:
**Never perform balance deductions, quota checks, or seat reservations via in-memory read-then-write.**
Mutations MUST be performed atomically at the database storage engine layer:
```sql
-- 🛡️ SECURE-CODE Invariant (Single Atomic Mutation)
UPDATE accounts 
SET balance = balance - :withdrawAmount 
WHERE id = :accountId AND balance >= :withdrawAmount;
-- Assert that rows_affected == 1. If 0, abort (Insufficient Funds).
```

---

## 4. Cascading Retry Storms & Full Jitter

### The Threat
When downstream microservices or databases experience brief latency spikes, naive AI-generated retry loops fire retries in lockstep:
```typescript
// ❌ VULNERABLE (Retry Storm / Self-Inflicted DDoS)
catch (err) {
  await sleep(1000); // 10,000 clients all retry simultaneously at +1s, crashing the database
  return retryRequest();
}
```

### The Invariant Rule:
**All retries MUST employ Exponential Backoff with Full Randomized Jitter.**
$$\text{Sleep} = \text{random}(0, \min(\text{MaxBackoff}, \text{BaseBackoff} \times 2^{\text{attempt}}))$$

```typescript
// 🛡️ SECURE-CODE (Exponential Backoff with Full Jitter)
async function fetchWithJitter(fn: () => Promise<any>, maxRetries = 3): Promise<any> {
  let attempt = 0;
  while (true) {
    try {
      return await fn();
    } catch (err) {
      attempt++;
      if (attempt > maxRetries) throw err;
      const baseDelay = 100 * Math.pow(2, attempt);
      const jitteredDelay = Math.random() * Math.min(baseDelay, 3000);
      await new Promise((res) => setTimeout(res, jitteredDelay));
    }
  }
}
```
