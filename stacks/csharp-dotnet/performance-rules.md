# C# & .NET Stack: Performance Rules (secure-code)

## 1. Async Deadlock Elimination (Sync-Over-Async Ban)
- NEVER call `.Result` or `.Wait()` on asynchronous `Task` objects. In ASP.NET Core, this causes thread-pool starvation and deadlocks.
- Always `await` tasks asynchronously from top-level controllers down to data access layers.

## 2. EF Core Client-Side Evaluation & Compiled Queries
- Ensure all LINQ expressions can be translated by the database provider. Avoid calling in-memory C# methods inside query `Where()` clauses that force EF Core to fetch entire tables into memory.
- Use `AsNoTracking()` on read-only queries to disable EF Core change-tracking overhead.

## 3. HttpClient Pooling via IHttpClientFactory
- Never instantiate `new HttpClient()` in transient scopes (causes socket exhaustion under high load). Always inject `IHttpClientFactory` or use typed clients.
