# Python Stack: Performance Rules (secure-code)

## 1. Zero Blocking Calls in Async Event Loops
- In FastAPI, Sanic, or Tornado, calling synchronous blocking code inside `async def` halts the entire event loop for all concurrent requests.
- Wrap synchronous blocking operations in `asyncio.to_thread(sync_func, *args)`.
- Use async database drivers (`asyncpg`, `aiomysql`, `motor`) with `AsyncSession` in SQLAlchemy.

## 2. Pydantic v2 Compiled Validation
- Utilize Pydantic v2 with the Rust-backed core engine. Avoid complex manual Python validation loops.
- Use `model_validate_json()` directly rather than `json.loads()` + `model_validate()`.

## 3. Worker Concurrency & Memory Leak Management
- In Celery or Gunicorn workers, configure `max_requests = 1000` (or `max_tasks_per_child`) to recycle workers and prevent gradual Python memory leaks from uncollectable cycles.
