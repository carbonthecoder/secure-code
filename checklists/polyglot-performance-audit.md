# ⚡ 40-POINT HIGH-PERFORMANCE & CORE WEB VITALS AUDIT

Use this checklist to ensure software runs with sub-millisecond efficiency, zero bottlenecks, and perfect Core Web Vitals.

## I. Database & Storage Efficiency (10 Points)
- [ ] 01. Zero N+1 queries: all relational joins use eager loading, JOIN FETCH, or DataLoader batching.
- [ ] 02. Composite indexes are created for all queries filtering on multiple columns.
- [ ] 03. All indexed column orders match the left-to-right query filter hierarchy.
- [ ] 04. No sequential table scans (`Seq Scan`) occur in critical user paths (`EXPLAIN ANALYZE` verified).
- [ ] 05. Read-only queries disable ORM entity change-tracking (`AsNoTracking()`, read-only sessions).
- [ ] 06. Large query results are paginated via keyset/cursor pagination rather than heavy `OFFSET` skips.
- [ ] 07. Connection pool sizes follow the core hardware formula: `(Cores * 2) + Effective Spindles`.
- [ ] 08. Redis pipelines are used when issuing multiple independent key fetches.
- [ ] 09. Redis keys have explicit TTLs to prevent unbounded memory growth.
- [ ] 10. Database write batches use multi-row `INSERT INTO ... VALUES (...)` instead of single inserts.

## II. Runtime, Memory & Concurrency (10 Points)
- [ ] 11. Async event loops (Node.js, Python FastAPI) have zero synchronous blocking operations.
- [ ] 12. Heavy CPU tasks (image resizing, hashing, compression) run in dedicated worker threads/processes.
- [ ] 13. Event listeners, timers, and WebSockets clean up properly on teardown (zero memory leaks).
- [ ] 14. Go code eliminates goroutine leaks via bounded contexts and guaranteed channel closures.
- [ ] 15. Rust code offloads sync blocking work to `tokio::task::spawn_blocking`.
- [ ] 16. C# code eliminates sync-over-async deadlocks: no `.Result` or `.Wait()` calls.
- [ ] 17. Java virtual threads (Loom) are enabled for I/O-heavy Spring Boot 3+ web services.
- [ ] 18. Hot memory allocations are pooled where applicable (`sync.Pool`, memory arenas).
- [ ] 19. HTTP clients are pooled singletons rather than re-instantiated per request.
- [ ] 20. Worker processes (Celery, Gunicorn) configure request limits to mitigate long-term GC fragmentation.

## III. Network, Caching & Gateway (10 Points)
- [ ] 21. Static hashed assets emit `Cache-Control: public, max-age=31536000, immutable`.
- [ ] 22. Dynamic read-heavy endpoints implement `stale-while-revalidate` caching headers.
- [ ] 23. Assets are pre-compressed with Brotli (br) level 11 at build time with Gzip fallbacks.
- [ ] 24. Dynamic HTTP payloads are compressed with Brotli level 4–5.
- [ ] 25. HTTP/2 or HTTP/3 (QUIC) is enabled on all reverse proxies and CDNs.
- [ ] 26. TLS 1.3 session resumption is configured to minimize SSL handshake latency.
- [ ] 27. TCP keep-alive and connection reuse are enabled between edge gateways and origin servers.
- [ ] 28. API response payloads strip unused fields to minimize serialization and wire transfer size.
- [ ] 29. Time-to-First-Byte (TTFB) on cached edge routes is under 50ms.
- [ ] 30. Third-party script domains are preconnected in HTML head (`<link rel="preconnect">`).

## IV. Core Web Vitals & Frontend (10 Points)
- [ ] 31. Largest Contentful Paint (LCP) is under 1.2 seconds on standard mobile network profiles.
- [ ] 32. Interaction to Next Paint (INP) is under 100 milliseconds for all interactive elements.
- [ ] 33. Cumulative Layout Shift (CLS) is under 0.05 across all responsive breakpoints.
- [ ] 34. All image and video elements declare explicit `width` and `height` attributes or CSS `aspect-ratio`.
- [ ] 35. Above-the-fold hero images use `fetchpriority="high"` and are preloaded in `<head>`.
- [ ] 36. Off-screen images and iframes use native `loading="lazy"`.
- [ ] 37. Modern image formats (AVIF and WebP) are served with responsive `srcset` resolutions.
- [ ] 38. Web fonts are self-hosted and declare `font-display: swap` to prevent FOIT text flicker.
- [ ] 39. JavaScript bundles are code-split dynamically; unused dependencies are tree-shaken out.
- [ ] 40. Long client-side CPU tasks yield back to the main thread via `scheduler.yield()`.
