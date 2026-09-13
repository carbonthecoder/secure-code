# Go (Golang) Stack: Security Rules (secure-code)

## 1. Concurrency & Data Race Elimination
- Access to shared maps or structs across goroutines MUST be guarded by `sync.RWMutex`, `sync.Mutex`, or `sync/atomic`.
- Run all tests and builds with the race detector enabled: `go test -race ./...`.
- Never write to a shared map concurrently (causes fatal runtime panic: `concurrent map writes`).

## 2. SQL & Query Parameterization
- Never use `fmt.Sprintf("SELECT ... %s", input)` with `database/sql` or GORM.
- Always use positional placeholders:
  ```go
  db.QueryRowContext(ctx, "SELECT id, name FROM users WHERE id = $1 AND tenant_id = $2", id, tenantID)
  ```

## 3. Cryptography & Timing Attacks
- Use `crypto/subtle.ConstantTimeCompare(a, b)` when verifying MACs, bearer tokens, or password hashes.
- Use `crypto/rand` for token generation, never `math/rand`.
