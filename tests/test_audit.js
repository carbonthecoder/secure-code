const assert = require("assert");

// 🛡️ SECURE-CODE Core Audit Scanner Unit Tests
// Tests the detection patterns to guarantee high-accuracy vulnerability detection
// without false-positive regressions.

const PATTERNS = {
  secret: /(AKIA[0-9A-Z]{16}|ghp_[0-9a-zA-Z]{36}|sk_live_[0-9a-zA-Z]{24})/,
  sqlInjection: /(SELECT|INSERT|UPDATE|DELETE).*\$\{.*\}/i,
  timingAttack: /(token|apiKey|signature|secret)\s*===/i,
  floatMoney: /(price|amount|balance|total)\s*[:=]\s*(number|float|double)\b/i,
  dangerousEval: /\b(eval|new\s+Function)\s*\(/,
  reactXSS: /dangerouslySetInnerHTML\s*=/,
  reverseTabnapping: /target\s*=\s*["']_blank["']/,
  insecureDeserialization: /\b(pickle\.loads?|yaml\.load\s*\([^,)]+\))\b/,
  jwtBypass: /(verify\s*=\s*False|algorithms\s*=\s*\[.*none.*\])/i,
  mockAuth: /(x-user-id.*\|\||TODO:.*add\s+auth|TODO:.*verify\s+session)/i,
  retryStorm: /(catch.*\{\s*sleep\(\d+\)|catch.*\{\s*await\s+new\s+Promise.*setTimeout.*\d{3,5}\))/i,
};

let passed = 0;
let total = 0;

function runTest(name, fn) {
  total++;
  try {
    fn();
    console.log(`  ✅ PASS: ${name}`);
    passed++;
  } catch (err) {
    console.error(`  ❌ FAIL: ${name}`);
    console.error(`     ${err.message}`);
  }
}

console.log("\n🧪 Running secure-code Audit Engine Unit Tests...\n");

// 1. Secret Detection
runTest("Detects hardcoded AWS access keys", () => {
  assert.ok(PATTERNS.secret.test('const awsKey = "AKIAIOSFODNN7EXAMPLE";'));
});

runTest("Ignores standard environment variable references", () => {
  assert.strictEqual(PATTERNS.secret.test("const key = process.env.AWS_KEY;"), false);
});

// 2. SQL String Interpolation
runTest("Detects SQL string interpolation in template literals", () => {
  assert.ok(PATTERNS.sqlInjection.test("db.query(`SELECT * FROM users WHERE id = ${userId}`)"));
});

runTest("Allows parameterized SQL queries", () => {
  assert.strictEqual(
    PATTERNS.sqlInjection.test("db.query('SELECT * FROM users WHERE id = $1', [userId])"),
    false
  );
});

// 3. Timing-Unsafe Equality
runTest("Detects === comparison on auth token", () => {
  assert.ok(PATTERNS.timingAttack.test("if (userProvidedToken === serverSecretToken)"));
});

// 4. Floating Point Currency
runTest("Detects float currency variable declaration", () => {
  assert.ok(PATTERNS.floatMoney.test("let itemPrice: number = 19.99;"));
});

runTest("Allows integer cents or bigint for money", () => {
  assert.strictEqual(PATTERNS.floatMoney.test("let priceInCents: bigint = 1999n;"), false);
});

// 5. Dangerous Eval
runTest("Detects eval() execution", () => {
  assert.ok(PATTERNS.dangerousEval.test("const res = eval(userInput);"));
});

runTest("Detects new Function() execution", () => {
  assert.ok(PATTERNS.dangerousEval.test("const fn = new Function('a', userInput);"));
});

// 6. React dangerouslySetInnerHTML
runTest("Detects dangerouslySetInnerHTML", () => {
  assert.ok(PATTERNS.reactXSS.test('<div dangerouslySetInnerHTML={{ __html: rawHtml }} />'));
});

// 7. Reverse Tabnapping
runTest("Detects target='_blank' link", () => {
  assert.ok(PATTERNS.reverseTabnapping.test('<a href="https://external.com" target="_blank">Link</a>'));
});

// 8. Python Insecure Deserialization
runTest("Detects Python pickle.loads()", () => {
  assert.ok(PATTERNS.insecureDeserialization.test("data = pickle.loads(payload)"));
});

// 9. JWT Verification Bypass
runTest("Detects disabled JWT verification", () => {
  assert.ok(PATTERNS.jwtBypass.test("jwt.decode(token, verify=False)"));
});

// 10. Mock Auth Fallbacks
runTest("Detects mock auth x-user-id fallback", () => {
  assert.ok(PATTERNS.mockAuth.test('const userId = req.headers["x-user-id"] || "admin";'));
});

runTest("Detects TODO: add auth comments", () => {
  assert.ok(PATTERNS.mockAuth.test("// TODO: add auth verification later"));
});

// 11. Static Unjittered Retry Storm
runTest("Detects static unjittered sleep in catch block", () => {
  assert.ok(PATTERNS.retryStorm.test("catch (e) { sleep(1000); retry(); }"));
});

console.log(`\n========================================`);
console.log(`Test Results: ${passed}/${total} Passed (${Math.round((passed / total) * 100)}%)`);
console.log(`========================================\n`);

if (passed !== total) {
  process.exit(1);
}
