# ⚡ DOCTRINE 02: EXTREME PERFORMANCE & WEB VITALS

> **Core Axiom**: Performance is a security feature (resilience against load spikes) and an absolute UX baseline. Systems must be engineered for sub-millisecond hot paths and flawless Core Web Vitals.

---

## 1. Latency Budgets & Target Metrics

| Layer / Metric | Strict Budget Target | Enforcement Rule |
| :--- | :--- | :--- |
| **In-Memory Cache (L1)** | `< 0.5 ms` | LRU / ARC cache with maximum element cap. |
| **Redis Cache (L2)** | `< 2.0 ms` | Pipeline commands, connection pool reuse. |
| **Database Query P95** | `< 15.0 ms` | Composite indexes on all joined/filtered columns. |
| **API Gateway TTFB** | `< 80.0 ms` | Edge termination, HTTP/2 or HTTP/3, TLS 1.3 session resumption. |
| **Largest Contentful Paint (LCP)**| `< 1.2 s` | Priority hints (`fetchpriority="high"`), preloading hero assets. |
| **Interaction to Next Paint (INP)**| `< 100 ms` | Avoid long main-thread tasks (> 50ms); use `scheduler.yield()`. |
| **Cumulative Layout Shift (CLS)** | `< 0.05` | Explicit aspect-ratio/width/height on all images and containers. |

---

## 2. Multi-Layer Caching Hierarchy

```
Browser / Edge (L3 CDN)
   ├── Cache-Control: public, max-age=31536000, immutable (Hashed static assets)
   └── Cache-Control: s-maxage=60, stale-while-revalidate=300 (Dynamic API responses)
          │
      API Gateway / Node Server (L1 Memory Cache)
         └── Node in-memory LRU cache (TTL: 5-30s for ultra-hot read endpoints)
                │
            Distributed Cache (L2 Redis)
               └── Redis Cluster with sliding expiration and compression
                      │
                  Database (PostgreSQL / MySQL)
```

### Stale-While-Revalidate Implementation
Always serve stale cached data immediately while asynchronously triggering a background refresh. This ensures users never wait on cache re-computations.

---

## 3. Core Web Vitals Engineering Protocol

### 3.1 Largest Contentful Paint (LCP) Invariants:
1. Preload the hero image in `<head>`:
   ```html
   <link rel="preload" as="image" href="/hero.avif" fetchpriority="high" type="image/avif" />
   ```
2. Self-host critical fonts and load with `font-display: swap` to prevent Flash of Invisible Text (FOIT).
3. Preconnect to external third-party origins using `<link rel="preconnect">`.

### 3.2 Interaction to Next Paint (INP) Invariants:
1. Break CPU-intensive tasks into chunks <= 50ms using Web Workers or `scheduler.yield()`.
2. Avoid synchronous layout thrashing (e.g. reading `offsetHeight` immediately after mutating the DOM).
3. Debounce or throttle high-frequency events (scroll, resize, search input).

### 3.3 Cumulative Layout Shift (CLS) Invariants:
1. Every `<img>`, `<video>`, and `<iframe>` tag MUST declare `width` and `height` attributes or CSS `aspect-ratio`.
2. Never inject dynamic content (banners, ads) above existing visible content without pre-allocating a skeleton placeholder.

---

## 4. Asset Compression & Pipeline

- **Static Compression**: Pre-compress static assets using **Brotli (br) level 11** at build time. Fall back to Gzip level 9 for legacy clients.
- **Dynamic Compression**: Serve dynamic API responses with Brotli level 4-5 (optimal balance of CPU overhead vs compression ratio).
- **Image Formats**: Serve **AVIF** first, falling back to **WebP**, and JPEG only as a final fallback:
  ```html
  <picture>
    <source srcset="image.avif" type="image/avif" />
    <source srcset="image.webp" type="image/webp" />
    <img src="image.jpg" width="800" height="600" loading="lazy" decoding="async" alt="Descriptive text" />
  </picture>
  ```
