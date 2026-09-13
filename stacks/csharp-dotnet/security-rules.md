# C# & .NET Stack: Security Rules (secure-code)

## 1. Mass Assignment & Over-Posting Defense
- Never bind raw HTTP request payloads directly to Entity Framework Core database entity models.
- Always map through dedicated ViewModels or Data Transfer Objects (DTOs) to prevent attackers from overriding sensitive fields (e.g. `IsAdmin`, `TenantId`).

## 2. LINQ & EF Core Injection Prevention
- Use parameterized LINQ queries.
- When writing raw SQL via `FromSqlRaw()`, NEVER format interpolated strings directly into the SQL string. Use `FromSqlInterpolated()` which automatically converts interpolated expressions into parameterized `DbParameter` instances.

## 3. Cryptography & Data Protection API
- Use `CryptographicOperations.FixedTimeEquals(a, b)` for constant-time comparisons.
- Use ASP.NET Core Data Protection API (`IDataProtector`) for encrypting cookies and anti-forgery tokens.
