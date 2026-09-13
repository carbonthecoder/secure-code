# Rust Stack: Security Rules (secure-code)

## 1. Zero Production Panic Policy
- Avoid raw `.unwrap()` or `.expect()` in production request handlers. A panic will abort or tear down the handling task.
- Use explicit pattern matching or the `?` error propagation operator with typed errors (e.g., `thiserror`, `anyhow`).

## 2. Unsound `unsafe` Block Prohibition
- Minimize and rigorously audit `unsafe` blocks. Do not use `unsafe` for micro-optimizations where safe Rust compiler optimizations achieve equivalent assembly.
- Validate pointer alignments and bounds when interfacing with C-FFI.

## 3. Constant-Time Cryptography
- Use the `subtle` crate (`ConstantTimeEq`) for verifying authentication tokens and message authentication codes.
- Use `ring` or `argon2` for cryptographic primitives.
