# Java & Kotlin Stack: Performance Rules (secure-code)

## 1. JPA & Hibernate N+1 Elimination
- Avoid `FetchType.EAGER` on entity relationships. Use `FetchType.LAZY` by default.
- Use `@EntityGraph` or explicit `JOIN FETCH` queries when loading entities with nested relationships.

## 2. Thread Pool & Connection Sizing
- Size HikariCP connection pools conservatively (e.g. 10-20 connections). Oversized connection pools increase contention and degrade throughput.
- In Spring Boot 3+ / Java 21+, leverage Virtual Threads (`spring.threads.virtual.enabled=true`) for high-throughput I/O bound web requests.
