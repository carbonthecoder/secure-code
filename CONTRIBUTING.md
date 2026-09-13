# 🤝 Contributing to `secure-code`

Thank you for your interest in making `secure-code` the world's leading security and performance standard for AI coding assistants and modern software engineering!

We welcome contributions from cybersecurity researchers, DevSecOps practitioners, SREs, and full-stack engineers across all programming languages.

---

## 🎯 Ways You Can Contribute

1. **Add a New Language or Framework Stack**:
   - Create a new directory in `stacks/<language-name>/`.
   - Provide two files:
     - `security-rules.md`: Invariants addressing language-specific memory safety, type juggling, deserialization, or injection traps.
     - `performance-rules.md`: Invariants addressing event loop blocking, memory allocations, connection pooling, and concurrency.
   - Update the detector in [`bin/secure-code.ps1`](bin/secure-code.ps1) and [`bin/secure-code.sh`](bin/secure-code.sh).

2. **Submit an Emerging Niche Attack Vector**:
   - Have you spotted a subtle bug or exploit that AI assistants consistently produce (e.g. race condition, timing side-channel, DNS rebinding, floating point truncation)?
   - Propose additions to [`doctrine/05-niche-vectors.md`](doctrine/05-niche-vectors.md) or [`checklists/niche-vectors-audit.md`](checklists/niche-vectors-audit.md).

3. **Contribute Production Reference Recipes**:
   - Expand our reference implementations in `recipes/` (e.g. Django, Elixir Phoenix, Axum, Laravel, NestJS).

4. **Improve the Scanner Engine (`secure-code audit`)**:
   - Add new high-precision AST or regex patterns to catch AI-generated anti-patterns without producing false positives.

---

## 📋 Rule Authoring Standards (No "Vibe Coding")

Every security or performance rule submitted to `secure-code` MUST adhere to this structure:

1. **Concrete Threat / Invariant Name**: Clearly describe the failure mode (e.g., *Insecure Deserialization via Pickle*).
2. **Why It Happens**: The root cause and how attackers exploit it or how systems degrade.
3. **Vulnerable Pattern (❌)**: Minimal code snippet showing what careless code or standard AI prompts produce.
4. **Hardened Invariant (🛡️)**: Production-ready code snippet showing the mathematically secure or high-performance pattern.

---

## 🛠️ Development & Local Testing

Before submitting a Pull Request, run the local verification suite:

```powershell
# Windows PowerShell
& ".\bin\secure-code.ps1" audit

# macOS / Linux
bash ./bin/secure-code.sh audit
```

Verify that:
- Markdown formatting is clean and cross-references link to valid files.
- Code snippets compile and pass type checks.
- Changes to detection scripts handle edge cases without throwing unhandled exceptions.

---

## 📜 Code of Conduct

We are committed to providing a welcoming, harassment-free community. Treat all contributors with mutual respect, constructive feedback, and professional rigor.
