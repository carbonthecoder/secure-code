# Ruby Stack: Performance Rules (secure-code)

## 1. N+1 Query Detection with Bullet
- Use the `bullet` gem in development to detect and prevent N+1 queries.
- Preload associations using `.includes(:association)`.

## 2. Batch Processing for Large Datasets
- Never load unbounded datasets into memory with `.all.each`.
- Use `.find_each(batch_size: 1000)` to stream records from PostgreSQL in batches without blowing out process memory.

## 3. Web Server Concurrency (Puma Tuning)
- Tune Puma threads and workers to match server CPU core counts:
  - Workers = `CPU_CORES`
  - Threads = 3–5 per worker for I/O-bound web traffic.
