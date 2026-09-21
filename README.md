<div align="center">

# secure-code

### The safety seatbelt for AI coding assistants.

**Stop Cursor, Claude, and Copilot from quietly creating security holes and broken code.**

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg?style=flat-square)](LICENSE)
[![Live Demo](https://img.shields.io/badge/Live_Demo-Interactive_Playground-00dc82.svg?style=flat-square)](https://carbonthecoder.github.io/secure-code/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-blue.svg?style=flat-square)](CONTRIBUTING.md)

<p align="center">
  <a href="https://carbonthecoder.github.io/secure-code/"><b>Try the Interactive Web Demo</b></a> •
  <a href="CHEATSHEET.md"><b>1-Page Cheatsheet</b></a> •
  <a href="SECURITY.md"><b>Security Policy</b></a> •
  <a href="CONTRIBUTING.md"><b>Contributing</b></a>
</p>

</div>

---

## What is this? (In 15 seconds)

AI coding tools like **Cursor**, **Claude Code**, and **Copilot** write code in seconds.

**The catch?** AI only cares about making the code run *right now*. It constantly forgets basic safety rules:
- It lets stranger A view stranger B's private files.
- It writes passwords in ways hackers can easily guess.
- It messes up math on prices, making money mysteriously vanish.
- It writes database commands that crash your app when multiple people use it.

**`secure-code` fixes this with one single command.**

---

## 🚀 Quickstart (1-Click Setup)

Run this once inside your project terminal:

```bash
npx github:carbonthecoder/secure-code inject
```

### What happens?
It automatically detects whether you use **Cursor**, **Claude**, or **Copilot**, and adds a simple safety rule file to your project. 

From that moment on, your AI assistant is forced to follow basic safety rules and **stops writing broken or hackable code**.

---

## 🩺 Scan your existing project right now

Already built an app with AI? Want to see if it sneaked any bugs into your code?

Run this in your terminal:

```bash
npx github:carbonthecoder/secure-code audit
```

It scans your files in 2 seconds and points out any hidden traps.

---

## 🔍 The 4 Scary Mistakes AI Always Makes (And How We Fix Them)

### 1. 🚪 The "Unlocked Hotel Room" (Private Data Leaks)
- **The Problem:** Imagine receiving key #101 at a hotel, but your key also opens room #102! When an AI writes code to fetch a file, it searches only by the ID number in the link. It forgets to check if the person asking actually owns it.
- **The Danger:** Anyone can change `/invoice/101` to `/invoice/102` in their browser and read someone else's private invoice!
- **What AI writes alone:**
  ```typescript
  // ❌ Unsafe: Hands the file to ANYONE who asks for this ID number
  const doc = await db.document.find({ where: { id: req.params.id } });
  ```
- **What it writes with secure-code:**
  ```typescript
  // ✅ Safe: Strictly verifies the logged-in user actually owns this file!
  const doc = await db.document.find({
    where: { 
      id: req.params.id, 
      ownerId: req.session.userId 
    }
  });
  ```

---

### 2. 💰 The "Ghost Pennies" (Broken Money Math)
- **The Problem:** Computers are surprisingly bad at decimal math. To a computer, `0.1 + 0.2` actually equals `0.30000000000000004`.
- **The Danger:** If you calculate shopping carts with decimals (`price * 0.0825`), fractions of cents get rounded off and your bank balance will quietly not match your customer receipts.
- **What AI writes alone:**
  ```typescript
  // ❌ Unsafe: Decimal math quietly corrupts account balances over time
  let total = price * 1.0825;
  ```
- **What it writes with secure-code:**
  ```typescript
  // ✅ Safe: Always counts in whole pennies (cents), never decimals!
  const totalInPennies = (subtotalPennies * 10825n + 5000n) / 10000n;
  ```

---

### 3. 💣 The "Search Box Prank" (Database Wipes)
- **The Problem:** A user types text into a search bar. The AI pastes whatever they typed directly into the database command.
- **The Danger:** A prankster types evil commands like `'; DROP TABLE users; --` into the search box, and the database executes it, wiping out your entire customer list!
- **What AI writes alone:**
  ```typescript
  // ❌ Unsafe: Glues user input directly into the database command
  db.query(`SELECT * FROM users WHERE id = '${userInput}'`);
  ```
- **What it writes with secure-code:**
  ```typescript
  // ✅ Safe: Tells the database: 'This is plain text, NEVER run it as code!'
  db.query('SELECT * FROM users WHERE id = $1', [userInput]);
  ```

---

### 4. ⏱️ The "Stopwatch Password Guess" (Easily Cracked Keys)
- **The Problem:** When you check a secret password with normal `===`, the computer checks letter-by-letter and stops the instant it hits a wrong letter.
- **The Danger:** A hacker with a stopwatch measures the server's response time in milliseconds. If the server took 1 microsecond longer to answer, the hacker knows the first letter was right! They guess your entire password letter-by-letter.
- **What AI writes alone:**
  ```typescript
  // ❌ Unsafe: Quits on the first wrong character (leaks timing clues)
  if (userToken === secretPassword) { ... }
  ```
- **What it writes with secure-code:**
  ```typescript
  // ✅ Safe: Takes the exact same time no matter what, revealing zero clues!
  if (!crypto.timingSafeEqual(Buffer.from(userToken), Buffer.from(secretPassword))) {
    return res.status(401).send('Wrong password');
  }
  ```

---

## 🎮 Try it in your browser (No installation needed)

Want to see this in action right now?  
Paste any code snippet into our online playground to watch it spot bugs and fix them live:

👉 **[https://carbonthecoder.github.io/secure-code/](https://carbonthecoder.github.io/secure-code/)**

---

## 🤖 Supported Tools & Languages

Works automatically with:
- **Cursor IDE** (`.cursorrules`)
- **Claude Code** (`CLAUDE.md`)
- **GitHub Copilot** (`copilot-instructions.md`)
- **Gemini / Antigravity / ChatGPT** (`AGENTS.md`)

Supports all major languages: **JavaScript, TypeScript, Python, Go, Rust, C#, Java, PHP, Ruby, and Mobile (Swift/Flutter)**.

---

## 📜 1-Page Cheatsheet

Keep our printable safety checklist open while reviewing code:  
👉 **[Open CHEATSHEET.md](CHEATSHEET.md)**

---

## ⚖️ License

MIT License — 100% Free and Open Source for personal, commercial, and startup projects.