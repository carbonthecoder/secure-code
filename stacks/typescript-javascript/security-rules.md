# TypeScript & JavaScript Stack: Security Rules (secure-code)

## 1. Prototype Pollution Elimination
- Never use recursive `Object.assign()` or deep merge libraries with unvalidated user JSON.
- Reject keys `__proto__`, `constructor`, `prototype`.
- When creating dictionary objects from external keys, use `Object.create(null)` or `new Map()`.

## 2. Insecure Deserialization & Evaluation
- Strict ban on `eval()`, `new Function()`, `setTimeout(string, ...)`, and `vm.runInThisContext()` with user input.
- Parse JSON only with `JSON.parse()`, wrapped in `try/catch`, followed immediately by `zod` schema parsing.

## 3. Strict Zod Schema Enforcements
- Always enable `.strict()` on object schemas to prevent parameter injection:
  ```typescript
  export const UserUpdateSchema = z.object({
    displayName: z.string().min(1).max(50).trim(),
    bio: z.string().max(250).optional()
  }).strict();
  ```

## 4. XSS & Dangerous HTML Attributes
- In React/Next.js: NEVER use `dangerouslySetInnerHTML` unless input is sanitized with `DOMPurify` using strict SVG/MathML disallowing rules.
- Avoid passing user strings directly to `href` attributes without verifying `protocol === 'https:'` or `protocol === 'http:'` (prevents `javascript:alert(1)`).
