# 🎯 25-POINT ELUSIVE NICHE ATTACK & LOGIC TRAPS AUDIT

A focused verification checklist targeting the subtle, elusive traps that AI coding assistants commonly miss.

## I. Cryptography & Numeric Integrity
- [ ] 01. **Constant-Time Compare**: All token/signature equality checks use constant-time functions.
- [ ] 02. **Financial Math**: Money is stored and calculated in integer cents or Decimal with Banker's Rounding.
- [ ] 03. **Homoglyph Impersonation**: Usernames and identity strings undergo Unicode NFKC normalization.
- [ ] 04. **DST Transitions**: Calendar and subscription math uses UTC intervals, not static millisecond additions.
- [ ] 05. **True CSPRNG**: Session identifiers and cryptokeys originate from system entropy, not `Math.random()`.

## II. File, Media & Archive Security
- [ ] 06. **Zip-Slip Check**: Archive extraction verifies target paths start with the authorized root directory.
- [ ] 07. **Zip Bomb Threshold**: Archive streams track total uncompressed byte size and terminate if quota is exceeded.
- [ ] 08. **Pixel Flood Quota**: Image headers are inspected for width/height boundaries before buffer allocation.
- [ ] 09. **EXIF GPS Stripping**: Uploaded image media is stripped of EXIF metadata before persistence or public display.
- [ ] 10. **MIME Sniffing Prevention**: Uploaded files serve with `X-Content-Type-Options: nosniff` and forced download or sandboxed domains.

## III. Protocol & Network Traps
- [ ] 11. **DNS Rebinding Guard**: SSRF resolvers pin resolved socket IPs rather than re-resolving hostnames.
- [ ] 12. **Alternative IP Encodings**: SSRF checks handle decimal, octal, hex, and IPv6 representations of loopback/private ranges.
- [ ] 13. **CSWSH Defense**: WebSocket upgrade handshakes explicitly validate the `Origin` header.
- [ ] 14. **Cache Stampede Guard**: Hot cache keys implement Probabilistic Early Expiration (XFetch) or single-flight mutexes.
- [ ] 15. **DB Connection Freeing**: No external network calls (Stripe, Twilio, AWS) are made inside open DB transactions.

## IV. Client, DOM & CSS Traps
- [ ] 16. **Reverse Tabnapping**: External links with `target="_blank"` include `rel="noopener noreferrer"`.
- [ ] 17. **CSS Injection Mitigation**: Content Security Policy blocks unauthorized stylesheets and inline CSS exfiltration.
- [ ] 18. **Subresource Integrity**: External CDN scripts declare valid cryptographic `integrity` attributes.
- [ ] 19. **Spectre Isolation**: Sensitive high-performance web pages declare `Cross-Origin-Opener-Policy: same-origin`.
- [ ] 20. **Markdown Image Exfiltration**: Markdown outputs sanitize external image tags to stop token leaks.

## V. Language-Specific Micro-Traps
- [ ] 21. **Prototype Pollution**: JSON deep merge routines reject `__proto__`, `constructor`, and `prototype`.
- [ ] 22. **PHP Type Juggling**: Strict typing (`declare(strict_types=1)`) and strict equality (`===`) are enforced.
- [ ] 23. **Ruby Strong Params**: Mass-assignment parameters are strictly whitelisted without `permit!`.
- [ ] 24. **C/C++ Bounded Arrays**: Vector and buffer accesses are bounds-checked or use `std::span` / `std::string_view`.
- [ ] 25. **Python Pickle Ban**: Object serialization uses JSON, Protocol Buffers, or safe YAML loaders only.
