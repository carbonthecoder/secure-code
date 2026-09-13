<div align="center">

```
 ███████╗███████╗ ██████╗██╗   ██╗██████╗ ███████╗     ██████╗ ██████╗ ██████╗ ███████╗
 ██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝
 ███████╗█████╗  ██║     ██║   ██║██████╔╝█████╗█████╗██║     ██║   ██║██║  ██║█████╗  
 ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██╔══╝╚════╝██║     ██║   ██║██║  ██║██╔══╝  
 ███████║███████╗╚██████╗╚██████╔╝██║  ██║███████╗    ╚██████╗╚██████╔╝██████╔╝███████╗
 ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝     ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
```

### **The Universal Production Security & High-Performance Standard for AI Agents & Modern Web**

*Turn Cursor, Claude Code, Antigravity, and GitHub Copilot into hardened DevSecOps and SRE engineers.*

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Standard: secure-code](https://img.shields.io/badge/standard-secure--code-059669.svg?logo=shield)](https://github.com/carbonthecoder/secure-code)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Polyglot: 12+ Ecosystems](https://img.shields.io/badge/polyglot-12%2B%20languages-8b5cf6.svg)](#polyglot-matrix)
[![OWASP & SRE Ready](https://img.shields.io/badge/compliance-OWASP%20%26%20SRE%20Ready-ef4444.svg)](#doctrine)

<p align="center">
  <a href="CHEATSHEET.md"><b>📖 1-Page Cheatsheet</b></a> •
  <a href="playground/index.html"><b>🎮 Interactive Playground</b></a> •
  <a href="LAUNCH_KIT.md"><b>🚀 Viral Launch Kit</b></a> •
  <a href="SECURITY.md"><b>🔒 Security Policy</b></a> •
  <a href="CONTRIBUTING.md"><b>🤝 Contributing</b></a>
</p>

</div>

---

```
                       HOW SECURE-CODE GUARDS YOUR SOFTWARE
                       
   [ AI Coding Assistant ]
              │
              ├── ❌ WITHOUT secure-code ──> Casual "Vibe" Code ──> 🚨 SQLi, IDOR, SSRF, Float Drift ──> 💥 Production Breach
              │
              └── 🛡️ WITH secure-code    ──> Invariant Engine   ──> ✅ Parameterized, Tenancy-Scoped,   ──> ⚡ Sub-ms, Unhackable
                                                                   Constant-Time, Zero N+1 Queries        Production Software
```

---

## ⚡ What is `secure-code`?

AI coding assistants (Cursor, Claude Code, Antigravity, GitHub Copilot, ChatGPT) write code fast—**but they routinely introduce critical security vulnerabilities, subtle logic traps, and crippling performance regressions**. 

They:
- Concatenate strings into SQL queries.
- Forget user tenancy checks (introducing Insecure Direct Object References / **IDOR**).
- Introduce **Timing Attacks** with simple `token === secret` comparisons.
- Compute financial transactions using **IEEE-754 floating point numbers** (`0.1 + 0.2 !== 0.3`).
- Leave endpoints open to **Server-Side Request Forgery (SSRF)** via internal IP probing.
- Trigger catastrophic database **N+1 queries** and connection pool starvation.
- Neglect **Core Web Vitals** (creating layout shifts, uncompressed bundles, and slow TTFB).

**`secure-code` eliminates these blindspots.** It is an enterprise-grade, universal engineering doctrine, AI rule system, and automated injection engine that hardens code written by AI and human developers alike across **every major language and framework on Earth**.

---

## ⚔️ Why `secure-code`? (The Comparison)

| Capability / Protection | Vanilla AI Assistants | Static Linters (ESLint/Sonar) | 🛡️ **`secure-code` Standard** |
| :--- | :---: | :---: | :---: |
| **Real-Time Generation Invariants** | ❌ None (Hallucinates shortcuts) | ❌ Only checks *after* code is written | **✅ Active guardrails injected in prompt** |
| **Zero IDOR Tenancy Defense** | ❌ Forgets tenant filters | ❌ Context-blind (Cannot know schema) | **✅ Mandatory user/tenant scoping** |
| **Timing-Safe Cryptography** | ❌ Defaults to `===` | ⚠️ Inconsistent warnings | **✅ Strict constant-time comparison** |
| **No Network in DB Transactions** | ❌ Starves connection pool | ❌ Cannot detect runtime lock states | **✅ Explicit isolation invariant** |
| **Zero Float Money Math** | ❌ Uses `float` / `number` | ❌ Allows floats for currency | **✅ Integer cents & Banker's rounding** |
| **SSRF & DNS Rebinding Defense** | ❌ Naive `fetch(url)` | ❌ Misses DNS rebinding | **✅ Drop-in socket IP resolver & CIDR filter** |
| **Core Web Vitals & Latency Budgets** | ❌ Completely ignored | ❌ Ignored | **✅ Sub-millisecond & LCP/INP/CLS targets** |
| **1-Click Polyglot Injection** | ❌ Manual prompting each time | ❌ Complex multi-tool setup | **✅ 1-second auto-detection for 10+ stacks** |

---

## 🧠 The 4 "Hidden AI Traps" Solved

Standard AI assistants optimize for *making code work right now*. They lack production time-awareness and adversarial human psychology. `secure-code` eliminates these 4 fatal blindspots:

1. **📦 AI Package Hallucination (Slopsquatting)**: AI models frequently invent fake package names. Attackers register these on npm/PyPI with Trojan `postinstall` scripts. `secure-code` enforces a strict **Standard Library First** and zero-unvetted dependency invariant.
2. **🎭 The "TODO: Add Auth Later" Mock Trap**: AI models love returning `req.headers["x-user-id"] || "admin"`. In fast-moving teams, this mock code accidentally ships to production. `secure-code` forces **Absolute Fail-Closed Security**—no mock fallback IDs permitted.
3. **💸 The Concurrency Double-Spend**: AI models check balances in application memory, oblivious to simultaneous millisecond requests. `secure-code` mandates **Atomic Row-Level Database Mutations** (`WHERE balance >= :amount`).
4. **🌪️ The Cascading Retry Storm**: AI writes static `sleep(1000)` retries. During minor hiccups, 10,000 clients retry in lockstep, knocking production offline. `secure-code` enforces **Exponential Backoff with Full Randomized Jitter**.

---

## 🚀 1-Second Quickstart (Inject into Any Repo)

### Zero-Install (NPX)
```bash
# Inject AI rules into active repo:
npx secure-code inject

# Run security & performance audit:
npx secure-code audit

# Install Git pre-commit hook:
npx secure-code install-hook
```

### Windows (PowerShell)
```powershell
# Inject AI rules:
& ".\bin\secure-code.ps1" inject

# Run security & performance audit:
& ".\bin\secure-code.ps1" audit

# Install Git pre-commit secret blocker hook:
& ".\bin\secure-code.ps1" install-hook
```

### macOS & Linux (Bash)
```bash
# Inject AI rules:
bash ./bin/secure-code.sh inject

# Run security & performance audit:
bash ./bin/secure-code.sh audit

# Install Git pre-commit secret blocker hook:
bash ./bin/secure-code.sh install-hook
```

### What Happens Automatically:
1. 🔍 **Detects your Tech Stack** (Next.js, FastAPI, Go Fiber, Rust Axum, Spring Boot, Rails, Laravel, etc.).
2. 🤖 **Detects your AI Assistants** (Cursor `.cursorrules`, Claude Code `CLAUDE.md`, Antigravity `GEMINI.md`, or Copilot).
3. 🛡️ **Non-Destructive Merge**: Safely injects hardened invariants into your existing rule files without overwriting user customizations.
4. 🩺 **Runs an Instant Audit**: Flags existing high-risk patterns (missing auth, hardcoded secrets, ReDoS regexes, unindexed queries).

---

## 🏛️ Repository Architecture

```
secure-code/
├── README.md                           # Master manifesto and quickstart
├── CHEATSHEET.md                       # 1-Page printable DevSecOps & SRE reference sheet
├── SECURITY.md                         # RFC-compliant vulnerability disclosure policy
├── LAUNCH_KIT.md                       # Viral launch kit (Hacker News, Reddit, X/Twitter, Product Hunt)
├── CONTRIBUTING.md                     # Community contribution guidelines
├── LICENSE                             # MIT License
├── package.json                        # NPX runner & npm test script
├── playground/                         # Interactive offline browser dashboard
│   └── index.html                      # Live code auditor & auto-hardener
├── tests/                              # Automated test suite
│   └── test_audit.js                   # Unit tests asserting 100% scanner accuracy
├── bin/                                # 1-Click Universal Injector & Scanner
│   ├── cli.js                          # Cross-platform Node.js / NPX bridge
│   ├── secure-code.ps1                 # Windows PowerShell engine
│   └── secure-code.sh                  # macOS/Linux POSIX Bash engine
├── doctrine/                           # Language-Agnostic Core Standards
│   ├── 01-zero-trust-security.md       # OWASP Top 10, API Top 10, IDOR, SSRF
│   ├── 02-extreme-performance.md       # Latency budgets, Web Vitals, Caching tiers
│   ├── 03-database-and-concurrency.md  # Indexing, connection pooling, locks, N+1
│   ├── 04-agentic-guardrails.md        # Prompt injection, tool sandboxes, cost caps
│   └── 05-niche-vectors.md             # Timing attacks, Zip-Slip, CSWSH, XFetch, homoglyphs
├── rules/                              # Drop-in rules for AI coding assistants
│   ├── AGENTS.md                       # Master standard AI agent directive
│   ├── GEMINI.md                       # Google Antigravity / Gemini CLI specification
│   ├── CLAUDE.md                       # Claude Code strict production protocol
│   ├── .cursorrules                    # Cursor IDE system instructions
│   └── copilot-instructions.md         # GitHub Copilot enterprise instructions
├── stacks/                             # Language- and framework-specific deep dives
│   ├── typescript-javascript/          # Next.js, Express, Fastify, Nest, Bun, Deno
│   ├── python/                         # FastAPI, Django, Flask, SQLAlchemy, Pydantic
│   ├── go/                             # Gin, Fiber, Echo, GORM, sqlx
│   ├── rust/                           # Axum, Actix, Tokio, Diesel
│   ├── csharp-dotnet/                  # ASP.NET Core, EF Core
│   ├── java-kotlin/                    # Spring Boot, Quarkus, Ktor
│   ├── php/                            # Laravel, Symfony
│   ├── ruby/                           # Rails, Sinatra
│   ├── c-cpp/                          # Modern C++, CMake, ASan, memory safety
│   └── mobile/                         # Flutter, React Native, Swift, Kotlin
├── recipes/                            # Production reference implementations
│   ├── nextjs-fullstack/               # Hardened Next.js App Router (Headers, CSP, Auth, DB)
│   ├── node-express-hardened/          # Hardened Node.js Express Server (Helmet, CORS, Zod, RateLimit)
│   ├── python-fastapi/                 # Hardened FastAPI + Async SQLAlchemy
│   ├── go-fiber/                       # Hardened Go Fiber API
│   ├── rust-axum/                      # Hardened Rust Axum API
│   └── spring-boot/                    # Hardened Spring Boot 3 & Spring Security 6 API
├── templates/                          # Ready-to-use drop-in security utilities
│   ├── safe-fetch/                     # Zero-SSRF HTTP clients (TypeScript & Python)
│   └── env-validator/                  # Fail-fast environment validators (TypeScript & Python)
├── benchmarks/                         # Side-by-side comparisons
│   └── vulnerable-ai-vs-secure-code.md # Concrete before/after code comparisons
├── checklists/                         # Pre-production release audits
│   ├── polyglot-security-audit.md      # 60-point multi-language DevSecOps verification
│   ├── polyglot-performance-audit.md   # 40-point latency, database & vitals checklist
│   └── niche-vectors-audit.md          # 25-point audit for elusive/obscure attack vectors
└── .github/workflows/
    └── secure-code-check.yml           # Automated CI/CD pull request gatekeeper
```

---

## 🌐 Polyglot Matrix: What We Cover

| Language | Security Enforcement | Performance Enforcement |
| :--- | :--- | :--- |
| **TypeScript / JS** | Prototype pollution freeze, CSP without `unsafe-inline`, strict Zod boundary validation | Event loop lag avoidance, streaming SSR, modern image formats, Brotli level 11 |
| **Python** | Safe deserialization (no raw pickle/yaml), ORM injection audit, constant-time compare | Zero blocking calls in async event loop, connection pool tuning, Pydantic v2 compile |
| **Go** | Goroutine leak elimination, race condition mutexes, parameterized sqlx | Buffer allocation reuse with `sync.Pool`, unbuffered I/O elimination, channel optimization |
| **Rust** | Zero panic policy (no raw `.unwrap()` in prod), safe FFI boundaries, constant-time token compare | Tokio blocking offload (`spawn_blocking`), zero-copy serde parsing, bounded channel buffers |
| **C# / .NET** | Mass-assignment model separation, Anti-forgery tokens, parameterized LINQ | Async deadlock prevention (no `.Result`/`.Wait()`), EF Core compiled queries, connection pooling |
| **Java / Kotlin** | JPA/Hibernate parameterization, Spring Security RBAC, XML external entity (XXE) blocking | JPA N+1 elimination via entity graphs, thread pool sizing, G1GC tuning |
| **PHP** | PDO prepared statements, safe serialization, Blade XSS prevention | OPcache preloading, Eloquent eager loading, query caching |
| **Ruby** | Strong Parameters enforcement, Brakeman compliance, SQL interpolation audit | Active Record bullet audit, batch processing (`find_each`), multi-threading tuning |
| **C / C++** | Buffer bounds checking, AddressSanitizer/UndefinedBehaviorSanitizer integration | Cache-line alignment, move semantics, zero heap reallocation in hot paths |
| **Mobile** | Encrypted SharedPreferences/KeyChain, SSL Pinning, jailbreak/root detection | 120 FPS UI thread preservation, off-thread image decodes, background drain prevention |

---

## 🛡️ Add the Badge to Your Project

Show the world your codebase adheres to the highest security and performance standards:

```markdown
[![Protected by secure-code](https://img.shields.io/badge/security-secure--code-059669.svg?logo=shield)](https://github.com/carbonthecoder/secure-code)
```

---

## 📜 License

MIT License. Free for open source, commercial, and enterprise development.
