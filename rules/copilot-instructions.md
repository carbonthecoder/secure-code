# GitHub Copilot Instructions - secure-code Standard

When suggesting code in this repository:
1. Always use parameterized queries for database operations. Never concatenate input strings into queries.
2. Ensure every entity modification verifies ownership through authenticated session IDs (zero IDOR).
3. Use timing-safe comparisons for cryptographic tokens and signatures.
4. Use integer cents or arbitrary-precision Decimal for financial values. Never use float or double for money.
5. Apply eager loading to avoid N+1 query patterns.
6. Ensure database queries only filter on indexed columns.
7. Disallow external HTTP requests inside database transaction scopes.
8. Enforce strong Content-Security-Policy and modern security headers.
