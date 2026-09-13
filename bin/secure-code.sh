#!/usr/bin/env bash
# 🛡️ secure-code Universal Polyglot Injection & Codebase Audit Engine (macOS & Linux)

set -e

ACTION="${1:-inject}"
TARGET_DIR="${2:-$(pwd)}"

echo ""
echo "🛡️  SECURE-CODE: Universal Production Security & Performance Standard"
echo "========================================================================"
echo ""

detect_stacks() {
  local dir="$1"
  local stacks=()

  [ -f "$dir/package.json" ] && stacks+=("TypeScript/JavaScript (Node.js)")
  ([ -f "$dir/requirements.txt" ] || [ -f "$dir/pyproject.toml" ]) && stacks+=("Python")
  [ -f "$dir/go.mod" ] && stacks+=("Go (Golang)")
  [ -f "$dir/Cargo.toml" ] && stacks+=("Rust")
  compgen -G "$dir/*.csproj" > /dev/null && stacks+=("C# (.NET)")
  ([ -f "$dir/pom.xml" ] || [ -f "$dir/build.gradle" ]) && stacks+=("Java/Kotlin")
  [ -f "$dir/composer.json" ] && stacks+=("PHP")
  [ -f "$dir/Gemfile" ] && stacks+=("Ruby")
  [ -f "$dir/CMakeLists.txt" ] && stacks+=("C/C++")
  [ -f "$dir/pubspec.yaml" ] && stacks+=("Flutter/Dart")

  if [ ${#stacks[@]} -eq 0 ]; then
    echo "Generic / Universal"
  else
    printf '%s\n' "${stacks[@]}"
  fi
}

detect_ai_tools() {
  local dir="$1"
  local tools=()

  ([ -f "$dir/.cursorrules" ] || [ -d "$dir/.cursor" ]) && tools+=("Cursor")
  ([ -f "$dir/GEMINI.md" ] || [ -d "$dir/.agents" ]) && tools+=("Google Antigravity")
  [ -f "$dir/CLAUDE.md" ] && tools+=("Claude Code")
  [ -f "$dir/.github/copilot-instructions.md" ] && tools+=("GitHub Copilot")

  if [ ${#tools[@]} -eq 0 ]; then
    echo "Universal AI Standard (AGENTS.md)"
  else
    printf '%s\n' "${tools[@]}"
  fi
}

run_inject() {
  local target="$1"
  echo "🔍 Inspecting target repository at: $target"
  
  echo ""
  echo "📦 Detected Stacks:"
  detect_stacks "$target" | sed 's/^/   - /'

  echo ""
  echo "🤖 Detected AI Environments:"
  detect_ai_tools "$target" | sed 's/^/   - /'

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(dirname "$SCRIPT_DIR")"
  AGENTS_SRC="$REPO_ROOT/rules/AGENTS.md"

  RULE_CONTENT=""
  if [ -f "$AGENTS_SRC" ]; then
    RULE_CONTENT=$(cat "$AGENTS_SRC")
  else
    RULE_CONTENT="# 🛡️ SECURE-CODE AGENT DIRECTIVE
- Parameterized queries ONLY. No SQL/ORM string interpolation.
- Zero IDOR: All queries MUST scope tenant_id & user_id from session.
- Constant-time comparison for all auth tokens.
- Zero floating point for money math. Use integer cents or Decimal.
- Prevent SSRF: Validate destination IPs against private/loopback CIDR blocks.
- Performance: Zero N+1 queries. Mandatory indexes on filtered fields."
  fi

  # Dynamically append detected stack-specific rules
  STACKS_DIR="$REPO_ROOT/stacks"
  for s in $(detect_stacks "$target"); do
    case "$s" in
      *"TypeScript/JavaScript"*) folder="typescript-javascript" ;;
      *"Python"*)                folder="python" ;;
      *"Go"*)                    folder="go" ;;
      *"Rust"*)                  folder="rust" ;;
      *"C#"*)                    folder="csharp-dotnet" ;;
      *"Java/Kotlin"*)           folder="java-kotlin" ;;
      *"PHP"*)                   folder="php" ;;
      *"Ruby"*)                  folder="ruby" ;;
      *"C/C++"*)                 folder="c-cpp" ;;
      *"Flutter/Dart"*)          folder="mobile" ;;
      *)                         folder="" ;;
    esac

    if [ -n "$folder" ] && [ -d "$STACKS_DIR/$folder" ]; then
      if [ -f "$STACKS_DIR/$folder/security-rules.md" ]; then
        RULE_CONTENT="$RULE_CONTENT"$'\n\n'"## STACK RULES: $s (Security)"$'\n'"$(cat "$STACKS_DIR/$folder/security-rules.md")"
        echo "   [+] Appended $s security rules"
      fi
      if [ -f "$STACKS_DIR/$folder/performance-rules.md" ]; then
        RULE_CONTENT="$RULE_CONTENT"$'\n\n'"## STACK RULES: $s (Performance)"$'\n'"$(cat "$STACKS_DIR/$folder/performance-rules.md")"
        echo "   [+] Appended $s performance rules"
      fi
    fi
  done

  MARKER_START="<!-- === SECURE-CODE ENFORCEMENT ENGINE START === -->"
  MARKER_END="<!-- === SECURE-CODE ENFORCEMENT ENGINE END === -->"

  # Inject or create AGENTS.md
  AGENTS_FILE="$target/AGENTS.md"
  if [ -f "$AGENTS_FILE" ]; then
    if ! grep -q "SECURE-CODE ENFORCEMENT ENGINE" "$AGENTS_FILE"; then
      echo -e "\n\n$MARKER_START\n$RULE_CONTENT\n$MARKER_END" >> "$AGENTS_FILE"
      echo "✅ Injected secure-code into existing AGENTS.md (Non-destructive merge)"
    fi
  else
    echo -e "$RULE_CONTENT\n" > "$AGENTS_FILE"
    echo "✅ Created AGENTS.md"
  fi

  # Inject into .cursorrules if present
  if [ -f "$target/.cursorrules" ]; then
    if ! grep -q "SECURE-CODE ENFORCEMENT ENGINE" "$target/.cursorrules"; then
      echo -e "\n\n$MARKER_START\n$RULE_CONTENT\n$MARKER_END" >> "$target/.cursorrules"
      echo "✅ Injected secure-code into .cursorrules"
    fi
  fi

  # Inject into GEMINI.md if present
  if [ -f "$target/GEMINI.md" ]; then
    if ! grep -q "SECURE-CODE ENFORCEMENT ENGINE" "$target/GEMINI.md"; then
      echo -e "\n\n$MARKER_START\n$RULE_CONTENT\n$MARKER_END" >> "$target/GEMINI.md"
      echo "✅ Injected secure-code into GEMINI.md"
    fi
  fi

  # Inject into CLAUDE.md if present
  if [ -f "$target/CLAUDE.md" ]; then
    if ! grep -q "SECURE-CODE ENFORCEMENT ENGINE" "$target/CLAUDE.md"; then
      echo -e "\n\n$MARKER_START\n$RULE_CONTENT\n$MARKER_END" >> "$target/CLAUDE.md"
      echo "✅ Injected secure-code into CLAUDE.md"
    fi
  fi

  # Auto-inject shield badge into target README.md if present
  if [ -f "$target/README.md" ]; then
    if ! grep -q "standard-secure--code" "$target/README.md"; then
      echo -e "\n[![Protected by secure-code](https://img.shields.io/badge/standard-secure--code-059669.svg?logo=shield)](https://github.com/carbonthecoder/secure-code)\n" >> "$target/README.md"
      echo "✅ Added secure-code verification shield badge to README.md"
    fi
  fi

  echo ""
  echo "🎉 Injection completed successfully! Your AI assistants will now uphold secure-code standards."
  echo ""
}

run_audit() {
  local target="$1"
  echo "🩺 Running secure-code security & performance audit on: $target"
  echo ""

  echo "1. Checking for hardcoded cloud secrets..."
  grep -rnEI '("|'\'')(AKIA[0-9A-Z]{16}|ghp_[0-9a-zA-Z]{36}|sk_live_[0-9a-zA-Z]{24})' \
    --exclude-dir={.git,node_modules,target,vendor,dist} "$target" || echo "   ✅ No hardcoded secrets found."

  echo "2. Checking for raw SQL interpolation..."
  grep -rnEI '(SELECT|INSERT|UPDATE|DELETE).*\$\{.*\}' \
    --include=*.ts --include=*.js --exclude-dir={node_modules,.next,dist} "$target" || echo "   ✅ No raw SQL template interpolation found."

  echo "3. Checking for eval() or new Function()..."
  grep -rnEI '\b(eval|new\s+Function)\s*\(' \
    --include=*.ts --include=*.js --include=*.py --exclude-dir={node_modules,.next,dist} "$target" || echo "   ✅ No dangerous eval execution found."

  echo "4. Checking for dangerouslySetInnerHTML..."
  grep -rnEI 'dangerouslySetInnerHTML\s*=' \
    --include=*.tsx --include=*.jsx --exclude-dir={node_modules,.next,dist} "$target" || echo "   ✅ No unverified dangerouslySetInnerHTML found."

  echo "5. Checking for reverse tabnapping (target='_blank')..."
  grep -rnEI 'target\s*=\s*["'']_blank["'']' \
    --include=*.html --include=*.tsx --include=*.jsx --exclude-dir={node_modules,.next,dist} "$target" | grep -v 'noopener' || echo "   ✅ No tabnapping vulnerabilities found."

  echo "6. Checking for insecure Python deserialization (pickle/yaml)..."
  grep -rnEI '\b(pickle\.loads?|yaml\.load\s*\()' \
    --include=*.py --exclude-dir={.venv,venv} "$target" || echo "   ✅ No insecure deserialization calls found."

  echo ""
  echo "✅ Audit scan completed."
}

run_install_hook() {
  local target="$1"
  echo "📦 Installing secure-code Git pre-commit hook in: $target"
  
  if [ ! -d "$target/.git" ]; then
    echo "❌ Git repository not found at '$target'. Run 'git init' first."
    return 1
  fi

  mkdir -p "$target/.git/hooks"
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(dirname "$SCRIPT_DIR")"
  HOOK_SRC="$REPO_ROOT/hooks/pre-commit"

  if [ -f "$HOOK_SRC" ]; then
    cp "$HOOK_SRC" "$target/.git/hooks/pre-commit"
  else
    cat << 'EOF' > "$target/.git/hooks/pre-commit"
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
EOF
  fi

  chmod +x "$target/.git/hooks/pre-commit"
  echo "✅ Successfully installed pre-commit hook into .git/hooks/pre-commit"
  echo "ℹ️ Staged commits will now automatically be verified against hardcoded secrets."
}

case "$ACTION" in
  inject|init)
    run_inject "$TARGET_DIR"
    ;;
  audit)
    run_audit "$TARGET_DIR"
    ;;
  install-hook)
    run_install_hook "$TARGET_DIR"
    ;;
  *)
    run_inject "$TARGET_DIR"
    ;;
esac
