# 🛡️ Security Policy

The `secure-code` project takes the security and integrity of software systems with the utmost seriousness. As a project establishing security standards for AI agents and production architectures, we hold our own codebase and recommendations to the highest level of scrutiny.

---

## 🔒 Supported Versions

We actively maintain and provide security patches for the following versions of `secure-code`:

| Version | Supported | Security Maintenance Status |
| :--- | :---: | :--- |
| `1.x` | ✅ | Active Maintenance & Critical Patches |
| `< 1.0` | ❌ | End of Life (Upgrade to 1.x) |

---

## 🚨 Reporting a Vulnerability

If you discover a security vulnerability, an insecure default invariant in our rules, a bypass in our drop-in utilities (e.g. SSRF bypass in `safe-fetch`), or a security hole in our CLI scripts, **please DO NOT file a public issue.**

Instead, please report it through coordinated disclosure:

1. **GitHub Private Advisory**: Open a draft security advisory via the [Security Advisories](https://github.com/carbonthecoder/secure-code/security/advisories) tab on GitHub.
2. **Security Team Email**: Alternatively, email details to: `security@secure-code.dev` (or your personal security contact).

### What to Include in Your Report:
- A clear description of the vulnerability or flawed invariant.
- Affected files, stacks, or script components.
- A minimal Proof-of-Concept (PoC) or exploit payload demonstrating the flaw.
- Any proposed remediation or patch.

---

## ⏱️ Response & Disclosure Timeline

- **Initial Acknowledgement**: Within **48 hours** of report receipt.
- **Triage & Assessment**: Within **5 business days**, confirming severity and scope.
- **Patch Release**: Within **14 business days** for high/critical vulnerabilities.
- **Public Disclosure**: Coordinated mutually after the patch is published and users have had an opportunity to update.

---

## 🏆 Security Hall of Fame

We believe in recognizing ethical security researchers. Contributors who responsibly report valid vulnerabilities or novel attack vectors will be credited in our [Hall of Fame](CONTRIBUTING.md#hall-of-fame) and release release notes.
