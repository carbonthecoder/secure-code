# Rust Stack: Performance Rules (secure-code)

## 1. Tokio Async Executor Starvation Prevention
- Never run long synchronous, blocking, or CPU-intensive computations (e.g. image hashing, heavy cryptography, synchronous file I/O) directly inside an `async fn`.
- Use `tokio::task::spawn_blocking` to move blocking tasks to Tokio's dedicated blocking thread pool.

## 2. Zero-Copy Deserialization with Serde
- In high-throughput network endpoints, leverage `serde` borrowing (`&'a str`) to deserialize JSON payloads without copying memory whenever the payload lifetime permits.
- Use `bytes::Bytes` for zero-copy slicing of network packets.

## 3. Bounded Channels & Memory Backpressure
- When communicating across threads or async tasks, prefer `tokio::sync::mpsc::channel(capacity)` over unbounded channels to prevent memory exhaustion under sudden traffic spikes.
