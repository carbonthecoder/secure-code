# 🗄️ DOCTRINE 03: DATABASE TUNING, CONCURRENCY & RACE CONDITIONS

> **Core Axiom**: The database is the single most critical bottleneck and stateful target in any software architecture. Queries must be strictly indexed, transactions kept minimal, and race conditions handled atomically.

---

## 1. Zero N+1 Query Invariant

An N+1 query occurs when an application executes 1 initial query to fetch N records, then enters a loop to execute 1 additional query for each record (resulting in N+1 roundtrips).

### The Invariant Rule:
**Never execute a database query inside an iterative loop.**

```typescript
// ❌ VULNERABLE (N+1 Query Catastrophe: 100 users = 101 queries)
const users = await db.user.findMany();
for (const user of users) {
  user.posts = await db.post.findMany({ where: { authorId: user.id } });
}

// 🛡️ SECURE-CODE (Single Eager Fetch or Batch DataLoader: 1 query)
const usersWithPosts = await db.user.findMany({
  include: { posts: true } // Handled via efficient JOIN or single WHERE authorId IN (...)
});
```

---

## 2. Database Indexing & Query Planning

1. **Mandatory Index Rule**: Every column appearing in a `WHERE`, `ORDER BY`, or `JOIN ON` clause MUST have an index.
2. **Composite Indexes (Left-to-Right Order)**: When filtering by multiple columns (e.g. `WHERE tenant_id = ? AND status = ? ORDER BY created_at DESC`), create a composite index in order of cardinality and sorting:
   ```sql
   CREATE INDEX idx_tenant_status_created ON orders (tenant_id, status, created_at DESC);
   ```
3. **Analyze Query Execution Plans**:
   Before deploying new queries to production, run `EXPLAIN (ANALYZE, BUFFERS)` to verify the query uses `Index Scan` rather than `Seq Scan` (Sequential Table Scan).

---

## 3. Transaction Isolation & The "No Network Calls in Transactions" Rule

### 3.1 Connection Starvation Trap
When a thread opens a database transaction, it holds an exclusive connection from the pool. If that code then issues an external network call (e.g. Stripe API, AWS S3, SendGrid), the connection remains blocked for hundreds or thousands of milliseconds. Under modest load, the entire connection pool starves, causing server-wide 504 Gateway Timeouts.

### The Invariant Rule:
**NEVER execute external HTTP calls, slow computations, or file I/O inside a database transaction block.**

```typescript
// ❌ VULNERABLE (Connection Pool Starvation)
await db.$transaction(async (tx) => {
  const order = await tx.order.create({ data: payload });
  const payment = await stripe.charges.create({ ... }); // 🚨 HOLDS DB LOCK FOR 1-3 SECONDS
  await tx.order.update({ where: { id: order.id }, data: { paid: true } });
});

// 🛡️ SECURE-CODE (Network Externalized from Transaction)
// Step 1: Create pending order in fast micro-transaction
const order = await db.order.create({ data: { ...payload, status: 'PENDING' } });

// Step 2: Execute network payment OUTSIDE transaction (Zero DB lock held)
const payment = await stripe.charges.create({ ... });

// Step 3: Update order status in fast micro-transaction
await db.order.update({
  where: { id: order.id },
  data: { status: payment.status === 'succeeded' ? 'PAID' : 'FAILED' }
});
```

---

## 4. Race Conditions: Optimistic vs Pessimistic Locking

When two concurrent requests attempt to decrement an inventory balance or transfer money:

### 4.1 Atomic Update with Filter
```sql
-- Atomic balance decrement ensuring balance cannot drop below zero:
UPDATE accounts 
SET balance = balance - 50 
WHERE id = :accountId AND balance >= 50;
-- If affected rows == 0, transaction aborts (Insufficient Funds).
```

### 4.2 Optimistic Locking with Versioning
Each record contains a `version` column. Updates assert the exact version read:
```sql
UPDATE products 
SET stock = stock - 1, version = version + 1 
WHERE id = :productId AND version = :currentVersion;
```

---

## 5. Connection Pool Sizing Formula

Set database pool sizes according to hardware limits rather than guesswork:
$$\text{Max Connections} = ((\text{Core Count} \times 2) + \text{Effective Spindle Count})$$

For PostgreSQL on a 4-core server, a connection pool of 9–12 connections delivers significantly higher throughput than 100 competing connections that exhaust CPU context switching and disk buffer caches.
