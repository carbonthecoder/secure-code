<#
.SYNOPSIS
    secure-code Universal Polyglot Injection & Codebase Audit Engine (Windows PowerShell)
.DESCRIPTION
    Auto-detects project stack, active AI coding tools, safely injects secure-code rules,
    and performs fast codebase security and performance audits.
#>

param (
    [Parameter(Position = 0)]
    [ValidateSet("inject", "audit", "init", "install-hook")]
    [string]$Action = "inject",

    [Parameter(Position = 1)]
    [string]$TargetDir = (Get-Location).Path,

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Write-Banner {
    Write-Host ""
    Write-Host "[*] SECURE-CODE: Universal Production Security and Performance Standard" -ForegroundColor Cyan
    Write-Host "========================================================================`n" -ForegroundColor DarkGray
}

function Detect-Stack {
    param([string]$Path)
    $detected = @()

    if (Test-Path (Join-Path $Path "package.json")) { $detected += "TypeScript/JavaScript (Node.js)" }
    if ((Test-Path (Join-Path $Path "requirements.txt")) -or (Test-Path (Join-Path $Path "pyproject.toml"))) { $detected += "Python" }
    if (Test-Path (Join-Path $Path "go.mod")) { $detected += "Go (Golang)" }
    if (Test-Path (Join-Path $Path "Cargo.toml")) { $detected += "Rust" }
    if (Get-ChildItem -Path $Path -Filter "*.csproj" -ErrorAction SilentlyContinue) { $detected += "C# (.NET)" }
    if ((Test-Path (Join-Path $Path "pom.xml")) -or (Test-Path (Join-Path $Path "build.gradle"))) { $detected += "Java/Kotlin" }
    if (Test-Path (Join-Path $Path "composer.json")) { $detected += "PHP" }
    if (Test-Path (Join-Path $Path "Gemfile")) { $detected += "Ruby" }
    if (Test-Path (Join-Path $Path "CMakeLists.txt")) { $detected += "C/C++" }
    if (Test-Path (Join-Path $Path "pubspec.yaml")) { $detected += "Flutter/Dart" }

    if ($detected.Count -eq 0) {
        $detected += "Generic / Universal"
    }
    return $detected
}

function Detect-AITools {
    param([string]$Path)
    $tools = @()

    if ((Test-Path (Join-Path $Path ".cursorrules")) -or (Test-Path (Join-Path $Path ".cursor"))) { $tools += "Cursor" }
    if ((Test-Path (Join-Path $Path "GEMINI.md")) -or (Test-Path (Join-Path $Path ".agents"))) { $tools += "Google Antigravity" }
    if (Test-Path (Join-Path $Path "CLAUDE.md")) { $tools += "Claude Code" }
    if (Test-Path (Join-Path $Path ".github\copilot-instructions.md")) { $tools += "GitHub Copilot" }

    if ($tools.Count -eq 0) {
        $tools += "Universal AI Standard (AGENTS.md)"
    }
    return $tools
}

function Invoke-Inject {
    param([string]$Path)
    Write-Host "[>] Inspecting target repository at: $Path" -ForegroundColor Yellow
    $stacks = Detect-Stack -Path $Path
    $aiTools = Detect-AITools -Path $Path

    Write-Host "`nDetected Stacks:" -ForegroundColor Green
    foreach ($s in $stacks) { Write-Host "   - $s" -ForegroundColor Gray }

    Write-Host "`nDetected AI Environments:" -ForegroundColor Green
    foreach ($t in $aiTools) { Write-Host "   - $t" -ForegroundColor Gray }

    $repoRoot = Split-Path -Parent $PSScriptRoot
    $rulesDir = Join-Path $repoRoot "rules"
    $agentsSource = Join-Path $rulesDir "AGENTS.md"

    if (Test-Path $agentsSource) {
        $ruleContent = Get-Content -Path $agentsSource -Raw
    } else {
        $ruleContent = @"
# SECURE-CODE AGENT DIRECTIVE
- Parameterized queries ONLY. No SQL/ORM string interpolation.
- Zero IDOR: All queries MUST scope tenant_id and user_id from session.
- Constant-time comparison for all auth tokens (crypto.timingSafeEqual / hmac.compare_digest).
- Zero floating point for money math. Use integer cents or Decimal.
- Prevent SSRF: Validate destination IPs against private/loopback CIDR blocks.
- Performance: Zero N+1 queries. Mandatory indexes on filtered fields. Web Vitals compliance.
"@
    }

    # Dynamically append detected stack-specific rules
    $stackFolderMap = @{
        "TypeScript/JavaScript (Node.js)" = "typescript-javascript"
        "Python"                          = "python"
        "Go (Golang)"                     = "go"
        "Rust"                            = "rust"
        "C# (.NET)"                       = "csharp-dotnet"
        "Java/Kotlin"                     = "java-kotlin"
        "PHP"                             = "php"
        "Ruby"                            = "ruby"
        "C/C++"                           = "c-cpp"
        "Flutter/Dart"                    = "mobile"
    }

    $stacksDir = Join-Path $repoRoot "stacks"
    foreach ($s in $stacks) {
        if ($stackFolderMap.ContainsKey($s)) {
            $folderName = $stackFolderMap[$s]
            $secFile = Join-Path (Join-Path $stacksDir $folderName) "security-rules.md"
            $perfFile = Join-Path (Join-Path $stacksDir $folderName) "performance-rules.md"
            
            if (Test-Path $secFile) {
                $ruleContent += "`n`n## STACK RULES: $s (Security)`n" + (Get-Content -Path $secFile -Raw)
                Write-Host "[+] Appended $s security rules" -ForegroundColor Cyan
            }
            if (Test-Path $perfFile) {
                $ruleContent += "`n`n## STACK RULES: $s (Performance)`n" + (Get-Content -Path $perfFile -Raw)
                Write-Host "[+] Appended $s performance rules" -ForegroundColor Cyan
            }
        }
    }

    $targetAgents = Join-Path $Path "AGENTS.md"
    $targetCursor = Join-Path $Path ".cursorrules"
    $targetGemini = Join-Path $Path "GEMINI.md"
    $targetClaude = Join-Path $Path "CLAUDE.md"

    $markerStart = "<!-- === SECURE-CODE ENFORCEMENT ENGINE START === -->"
    $markerEnd = "<!-- === SECURE-CODE ENFORCEMENT ENGINE END === -->"
    $injectionPayload = "`n`n$markerStart`n$ruleContent`n$markerEnd`n"

    # Inject into AGENTS.md (Master standard)
    if (Test-Path $targetAgents) {
        $existing = Get-Content -Path $targetAgents -Raw
        if ($existing -notmatch "SECURE-CODE ENFORCEMENT ENGINE") {
            Add-Content -Path $targetAgents -Value $injectionPayload
            Write-Host "[+] Injected secure-code into existing AGENTS.md (Non-destructive merge)" -ForegroundColor Green
        } else {
            Write-Host "[i] secure-code already present in AGENTS.md" -ForegroundColor DarkGray
        }
    } else {
        Set-Content -Path $targetAgents -Value ($ruleContent + "`n")
        Write-Host "[+] Created AGENTS.md" -ForegroundColor Green
    }

    # Inject into .cursorrules if user has Cursor
    if ($aiTools -contains "Cursor" -or (Test-Path $targetCursor)) {
        $existing = if (Test-Path $targetCursor) { Get-Content -Path $targetCursor -Raw } else { "" }
        if ($existing -notmatch "SECURE-CODE ENFORCEMENT ENGINE") {
            Add-Content -Path $targetCursor -Value $injectionPayload
            Write-Host "[+] Injected secure-code into .cursorrules" -ForegroundColor Green
        }
    }

    # Inject into GEMINI.md for Antigravity
    if ($aiTools -contains "Google Antigravity" -or (Test-Path $targetGemini)) {
        $existing = if (Test-Path $targetGemini) { Get-Content -Path $targetGemini -Raw } else { "" }
        if ($existing -notmatch "SECURE-CODE ENFORCEMENT ENGINE") {
            Add-Content -Path $targetGemini -Value $injectionPayload
            Write-Host "[+] Injected secure-code into GEMINI.md" -ForegroundColor Green
        }
    }

    # Inject into CLAUDE.md
    if ($aiTools -contains "Claude Code" -or (Test-Path $targetClaude)) {
        $existing = if (Test-Path $targetClaude) { Get-Content -Path $targetClaude -Raw } else { "" }
        if ($existing -notmatch "SECURE-CODE ENFORCEMENT ENGINE") {
            Add-Content -Path $targetClaude -Value $injectionPayload
            Write-Host "[+] Injected secure-code into CLAUDE.md" -ForegroundColor Green
        }
    }
    # Auto-inject shield badge into target README.md if present
    $targetReadme = Join-Path $Path "README.md"
    if (Test-Path $targetReadme) {
        $readmeContent = Get-Content -Path $targetReadme -Raw
        if ($readmeContent -notmatch "standard-secure--code") {
            $badgeMarkdown = "`n[![Protected by secure-code](https://img.shields.io/badge/standard-secure--code-059669.svg?logo=shield)](https://github.com/carbonthecoder/secure-code)`n"
            if ($readmeContent -match '^(#\s+[^\r\n]+)([\r\n]+)') {
                $updatedReadme = $readmeContent -replace '^(#\s+[^\r\n]+)([\r\n]+)', "`$1`$2$badgeMarkdown"
                Set-Content -Path $targetReadme -Value $updatedReadme
            } else {
                Set-Content -Path $targetReadme -Value ($badgeMarkdown + $readmeContent)
            }
            Write-Host "[+] Added secure-code verification shield badge to README.md" -ForegroundColor Green
        }
    }

    Write-Host "`n[OK] Injection completed successfully! Your AI assistants will now uphold secure-code standards.`n" -ForegroundColor Cyan
}

function Invoke-Audit {
    param([string]$Path)
    Write-Host "[*] Running secure-code security and performance audit on: $Path`n" -ForegroundColor Yellow

    $files = Get-ChildItem -Path $Path -Recurse -File -Exclude "*.git*", "*node_modules*", "*dist*", "*.next*", "*vendor*", "*target*" -ErrorAction SilentlyContinue

    $foundIssues = 0

    foreach ($file in $files) {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }

        # Check 1: Hardcoded secrets
        if ($content -match '(AKIA[0-9A-Z]{16}|ghp_[0-9a-zA-Z]{36}|sk_live_[0-9a-zA-Z]{24})') {
            Write-Host "[-] [CRITICAL SECRET] $($file.Name): Potential hardcoded API secret detected!" -ForegroundColor Red
            $foundIssues++
        }

        # Check 2: Raw SQL interpolation
        if ($content -match '(?i)(SELECT|INSERT|UPDATE|DELETE).*\$\{.*\}') {
            Write-Host "[!] [SQL INJECTION RISK] $($file.Name): Potential string interpolation in SQL query." -ForegroundColor Yellow
            $foundIssues++
        }

        # Check 3: Timing-unsafe token comparison
        if ($content -match '(?i)(token|apiKey|signature|secret)\s*===') {
            Write-Host "[i] [TIMING ATTACK RISK] $($file.Name): Using === to compare security tokens. Consider constant-time compare." -ForegroundColor DarkYellow
            $foundIssues++
        }

        # Check 4: Float money calculation
        if ($content -match '(price|amount|balance|total)\s*[:=]\s*(number|float|double)\b') {
            Write-Host "[i] [FINANCIAL DRIFT RISK] $($file.Name): Money variable defined as float/number. Prefer integer cents or Decimal." -ForegroundColor DarkYellow
            $foundIssues++
        }

        # Check 5: Dangerous eval or dynamic function execution
        if ($content -match '\b(eval|new\s+Function)\s*\(') {
            Write-Host "[!] [CODE EXECUTION RISK] $($file.Name): Found eval() or new Function(). Disallowed in secure-code." -ForegroundColor Red
            $foundIssues++
        }

        # Check 6: React dangerouslySetInnerHTML
        if ($content -match 'dangerouslySetInnerHTML\s*=') {
            Write-Host "[!] [XSS RISK] $($file.Name): Found dangerouslySetInnerHTML. Ensure strict sanitization (DOMPurify)." -ForegroundColor Yellow
            $foundIssues++
        }

        # Check 7: Reverse Tabnapping on target="_blank"
        if ($content -match 'target\s*=\s*["'']_blank["'']' -and $content -notmatch 'noopener') {
            Write-Host "[i] [REVERSE TABNAPPING] $($file.Name): External link target='_blank' missing rel='noopener noreferrer'." -ForegroundColor DarkYellow
            $foundIssues++
        }

        # Check 8: Insecure deserialization in Python
        if ($content -match '\b(pickle\.loads?|yaml\.load\s*\([^,)]+\))\b') {
            Write-Host "[-] [INSECURE DESERIALIZATION] $($file.Name): Detected raw pickle or unsafe yaml.load(). Severe RCE risk!" -ForegroundColor Red
            $foundIssues++
        }

        # Check 9: JWT verification bypass
        if ($content -match '(?i)(verify\s*=\s*False|algorithms\s*=\s*\[.*none.*\])') {
            Write-Host "[-] [JWT BYPASS RISK] $($file.Name): Detected disabled JWT verification or 'none' algorithm!" -ForegroundColor Red
            $foundIssues++
        }

        # Check 10: Mock auth fallback or temporary auth bypass
        if ($content -match '(?i)(x-user-id.*\|\||TODO:.*add\s+auth|TODO:.*verify\s+session)') {
            Write-Host "[-] [MOCK AUTH RISK] $($file.Name): Found potential mock auth fallback or unverified header trust!" -ForegroundColor Red
            $foundIssues++
        }

        # Check 11: Static unjittered retry loop
        if ($content -match '(?i)(catch.*\{\s*sleep\(\d+\)|catch.*\{\s*await\s+new\s+Promise.*setTimeout.*\d{3,5}\))') {
            Write-Host "[i] [RETRY STORM RISK] $($file.Name): Found static unjittered retry timer. Use Exponential Backoff + Jitter." -ForegroundColor DarkYellow
            $foundIssues++
        }
    }

    if ($foundIssues -eq 0) {
        Write-Host "[+] Clean Audit: No obvious high-risk patterns detected!" -ForegroundColor Green
    } else {
        Write-Host "`n[!] Audit completed with $foundIssues item(s) flagged for review." -ForegroundColor Yellow
    }
}

function Invoke-InstallHook {
    param([string]$Path)
    Write-Host "[*] Installing secure-code Git pre-commit hook in: $Path" -ForegroundColor Yellow

    $gitDir = Join-Path $Path ".git"
    if (-not (Test-Path $gitDir)) {
        Write-Host "[-] Git repository not found at '$Path'. Please run 'git init' first." -ForegroundColor Red
        return
    }

    $hooksDir = Join-Path $gitDir "hooks"
    if (-not (Test-Path $hooksDir)) {
        New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null
    }

    $repoRoot = Split-Path -Parent $PSScriptRoot
    $sourceHook = Join-Path (Join-Path $repoRoot "hooks") "pre-commit"
    $targetHook = Join-Path $hooksDir "pre-commit"

    if (Test-Path $sourceHook) {
        Copy-Item -Path $sourceHook -Destination $targetHook -Force
    } else {
        $fallback = @'
#!/usr/bin/env bash
# secure-code Pre-Commit Hook
STAGED_ENV=$(git diff --cached --name-only | grep -E '^(\.env|\.env\.local)$')
if [ -n "$STAGED_ENV" ]; then
  echo "[-] ERROR: Attempting to commit environment secret file: $STAGED_ENV"
  exit 1
fi
SECRET_PATTERN='(AKIA[0-9A-Z]{16}|ghp_[0-9a-zA-Z]{36}|sk_live_[0-9a-zA-Z]{24})'
if git diff --cached | grep -E "$SECRET_PATTERN" > /dev/null; then
  echo "[-] ERROR: Hardcoded API secret detected in staged changes!"
  exit 1
fi
exit 0
'@
        Set-Content -Path $targetHook -Value $fallback
    }

    Write-Host "[+] Successfully installed secure-code Git pre-commit hook into .git/hooks/pre-commit" -ForegroundColor Green
    Write-Host "[i] Staged commits will now automatically be verified against hardcoded secrets and leaked .env files." -ForegroundColor Cyan
}

# Main Execution Flow
Write-Banner

switch ($Action.ToLower()) {
    "inject"       { Invoke-Inject -Path $TargetDir }
    "init"         { Invoke-Inject -Path $TargetDir }
    "audit"        { Invoke-Audit -Path $TargetDir }
    "install-hook" { Invoke-InstallHook -Path $TargetDir }
    default        { Invoke-Inject -Path $TargetDir }
}
