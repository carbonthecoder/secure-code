# PHP Stack: Performance Rules (secure-code)

## 1. OPcache Preloading
- Enable OPcache with `opcache.enable=1` and configure `opcache.preload` to load framework classes into shared memory before requests arrive.

## 2. Eloquent Eager Loading
- Prevent N+1 queries by eager loading relationships with `with(['relation'])`.
- Enable Laravel's `Model::preventLazyLoading(!app()->isProduction());` during development.

## 3. Config & Route Caching
- In production deployment pipelines, always run:
  - `php artisan config:cache`
  - `php artisan route:cache`
  - `php artisan view:cache`
