# Python Stack: Security Rules (secure-code)

## 1. Remote Code Execution via Insecure Deserialization
- **Strict Ban on `pickle.loads()`** on untrusted data. Pickle execution allows arbitrary Python bytecode execution (`__reduce__` exploit).
- Use `json.loads()` or `msgpack` with strict schema validation.
- Avoid `yaml.load()` without `Loader=yaml.SafeLoader` (`yaml.safe_load()`).

## 2. SQL & ORM Injection Traps
- When using SQLAlchemy, Peewee, or Django ORM:
  - NEVER use `text("SELECT * FROM users WHERE email = '" + email + "'")`.
  - ALWAYS use bound parameters: `text("SELECT * FROM users WHERE email = :email")` with `{"email": email}`.
  - In Django ORM, avoid `extra(where=["..."])` and `RawSQL` with unparameterized strings.

## 3. Cryptographic and Timing Defense
- Use `hmac.compare_digest(a, b)` for signature, token, and API key comparisons.
- Use the `secrets` module (`secrets.token_hex`, `secrets.token_urlsafe`) instead of the `random` module for any security-sensitive random value.
- Use `argon2-cffi` or `passlib.hash.argon2` for password hashing.
