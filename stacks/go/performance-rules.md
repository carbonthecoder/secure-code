# Go (Golang) Stack: Performance Rules (secure-code)

## 1. Goroutine Leak Elimination
- Every spawned goroutine must have a bounded lifetime managed via `context.Context` cancellation or a guaranteed channel close.
- Never write to an unbuffered channel in a goroutine without an active listener, or the goroutine will block indefinitely and leak memory.

## 2. Allocation & Garbage Collection Tuning
- In hot request paths, reuse heap-allocated byte slices and structs using `sync.Pool`.
- Preallocate slice capacity when length is known: `make([]T, 0, expectedCapacity)`.
- Use `strings.Builder` with `Grow(size)` for string concatenation instead of repeatedly appending with `+`.

## 3. Buffered I/O & Connection Reuse
- Always wrap raw network sockets and file handles in `bufio.Reader` and `bufio.Writer`.
- Use a single shared `http.Client` with configured `MaxIdleConns` and `IdleConnTimeout` instead of instantiating new clients per request.
