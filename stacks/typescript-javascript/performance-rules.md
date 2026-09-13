# TypeScript & JavaScript Stack: Performance Rules (secure-code)

## 1. Node.js Event Loop Lag Minimization
- Never run CPU-heavy operations (e.g., cryptographic hashing, image processing, massive JSON parsing) synchronously on the main event loop.
- Offload to `worker_threads` or dedicated worker microservices.
- Track event loop delay via `perf_hooks.monitorEventLoopDelay()`.

## 2. Next.js Waterfall Fetch Elimination
- Never await sequential independent promises:
  ```typescript
  // ❌ SLOW (Sequential Waterfall: takes T1 + T2)
  const user = await getUser();
  const settings = await getSettings();

  // ⚡ FAST (Concurrent: takes max(T1, T2))
  const [user, settings] = await Promise.all([getUser(), getSettings()]);
  ```
- In React Server Components, stream slower subtrees with `<Suspense fallback={<Skeleton />}>`.

## 3. Memory Leak Prevention
- Always remove event listeners in `useEffect` cleanup or EventEmitter lifecycles.
- Clear `setInterval` and `setTimeout` handlers upon component/service unmount.
- Use `WeakMap` or `WeakSet` for object-keyed metadata to allow garbage collection.
