#!/usr/bin/env node

const { spawn } = require("child_process");
const path = require("path");

// 🛡️ SECURE-CODE Universal Cross-Platform CLI Entrypoint
// Bridges NPX invocations directly to native PowerShell / Bash engines.

const args = process.argv.slice(2);
const isWindows = process.platform === "win32";

const scriptPath = isWindows
  ? path.join(__dirname, "secure-code.ps1")
  : path.join(__dirname, "secure-code.sh");

let child;

if (isWindows) {
  child = spawn(
    "powershell.exe",
    ["-ExecutionPolicy", "Bypass", "-File", scriptPath, ...args],
    { stdio: "inherit" }
  );
} else {
  child = spawn("bash", [scriptPath, ...args], { stdio: "inherit" });
}

child.on("exit", (code) => {
  process.exit(code || 0);
});

child.on("error", (err) => {
  console.error("❌ Failed to execute secure-code engine:", err.message);
  process.exit(1);
});
