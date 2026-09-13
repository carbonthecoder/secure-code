# PHP Stack: Security Rules (secure-code)

## 1. Type Juggling & Strict Equality
- Always declare `declare(strict_types=1);` at the beginning of every PHP file.
- Never use loose comparisons (`==`). Always use strict comparisons (`===`) to avoid PHP type juggling auth bypasses (`"0e12345" == "0"` evaluates to true).
- Use `hash_equals($known_string, $user_string)` for constant-time cryptographic comparisons.

## 2. Insecure Object Deserialization
- Never call `unserialize()` on untrusted user strings. Use `json_decode()` with schema validation.

## 3. Blade & HTML Escaping
- In Laravel Blade templates, always use `{{ $variable }}` for automatic HTML escaping.
- Never use `{!! $raw_variable !!}` with user-submitted data.
