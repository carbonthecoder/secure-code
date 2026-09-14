<div align="center">

# secure-code

### The safety seatbelt for AI coding assistants.

Stop Cursor, Claude Code, and Copilot from quietly introducing user data leaks, broken money math, and hackable database queries.

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg?style=flat-square)](LICENSE)
[![Live Demo](https://img.shields.io/badge/Live_Demo-Interactive_Playground-00dc82.svg?style=flat-square)](https://carbonthecoder.github.io/secure-code/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-blue.svg?style=flat-square)](CONTRIBUTING.md)

<p align="center">
  <a href="https://carbonthecoder.github.io/secure-code/"><b>Try Interactive Demo</b></a> •
  <a href="CHEATSHEET.md"><b>1-Page Cheatsheet</b></a> •
  <a href="SECURITY.md"><b>Security Policy</b></a> •
  <a href="CONTRIBUTING.md"><b>Contributing</b></a>
</p>

</div>

---

## ? Quickstart (Zero Install)

Run this once in your project terminal:

```bash
# Automatically inject hardened safety rules into .cursorrules, CLAUDE.md, or AGENTS.md:
npx github:carbonthecoder/secure-code inject
```

Want to scan your existing project for hidden AI bugs?

```bash
# Scan your codebase for data leaks, cracked keys, and raw SQL queries:
npx github:carbonthecoder/secure-code audit
```

---

## ?? The Problem: AI Writes Fast, But Forgets Safety Rules

When you build apps using Cursor, Claude Code, Copilot, or ChatGPT, the AI optimizes for **making the code run right now**, not making it secure or fast for production.

Behind your back, AI routinely introduces the same 4 critical mistakes:

1. **User Data Leaks (IDOR)**: The AI writes `WHERE id = :id` without checking if the logged-in user owns the record. Any user can type a different ID in their browser and view or delete someone else’s private data.
2. **Easy-to-Crack Secret Keys**: It checks passwords and webhook tokens with simple `if (token === secret)`. This allows hackers to deduce your secret character-by-character by measuring server response times in milliseconds (timing side-channel attacks).
3. **Broken Money Math**: It calculates prices and taxes using floating-point decimals (`price * 0.0825`). Computers cannot represent decimals precisely (`0.1 + 0.2 === 0.30000000000000004`), quietly corrupting user account balances over time.
4. **Frozen Servers**: It places external network calls (like Stripe or Twilio) inside open database transactions. When multiple users visit your app, this holds database locks and freezes your entire server.

---

## ??? The Fix: What AI Writes Before vs After

### 1. Fetching a Private Document

```typescript
// ? Vanilla AI (Anyone can change the ID in the URL to view any user's file):
const doc = await db.document.findUnique({
  where: { id: req.params.id }
});

// ??? With secure-code (Strictly verifies the logged-in user owns it):
const doc = await db.document.findFirst({
  where: {
    id: req.params.id,
    userId: req.session.user.id // Only returns if the logged-in user owns it!
  }
});
```

### 2. Checking a Webhook Token or Secret

```typescript
// ? Vanilla AI (Exits on first wrong byte — leaks secrets via microsecond timing):
if (userToken === process.env.WEBHOOK_SECRET) { ... }

// ??? With secure-code (Constant-time check prevents timing attacks):
if (!crypto.timingSafeEqual(Buffer.from(userToken), Buffer.from(expectedSecret))) {
  return res.status(401).send("Unauthorized");
}
```

### 3. Calculating Financial Totals

```typescript
// ? Vanilla AI (Float rounding drift quietly corrupts financial ledgers):
let total = price * 1.0825;

// ??? With secure-code (Integer cents with Banker's rounding):
const totalCents = (subtotalCents * 10825n + 5000n) / 10000n;
```

---

## ?? Supported AI Assistants & Environments

`secure-code` works with any AI tool by appending strict, non-destructive safety invariants to your existing rules file:

- **Cursor IDE** ? `.cursorrules`
- **Anthropic Claude Code** ? `CLAUDE.md`
- **Google Antigravity / Gemini CLI** ? `GEMINI.md`
- **GitHub Copilot** ? `copilot-instructions.md`
- **Any Autonomous Agent** ? `AGENTS.md`

### Polyglot Support (10+ Languages)
Works out of the box for **TypeScript/JavaScript, Python, Go, Rust, C#/.NET, Java/Kotlin, PHP, Ruby, C++, and Mobile (Swift/Flutter)**.

---

## ?? Interactive Browser Playground

Don't want to run commands in the terminal yet?  
Test your code and watch the live auditor catch bugs in real-time on our web playground:

?? **[https://carbonthecoder.github.io/secure-code/](https://carbonthecoder.github.io/secure-code/)**

---

## ?? Printable Cheatsheet

Keep our 1-page DevSecOps reference card open on your second monitor during PR reviews:  
?? **[Open CHEATSHEET.md](CHEATSHEET.md)**

---

## ?? Contributing

Have a new AI bug pattern, framework recipe, or language stack to add?  
Pull requests are welcome! Check out [CONTRIBUTING.md](CONTRIBUTING.md).

## ?? License

MIT License — free for personal, commercial, and enterprise software.
