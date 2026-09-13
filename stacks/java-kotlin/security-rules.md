# Java & Kotlin Stack: Security Rules (secure-code)

## 1. JNDI / Log4j & Deserialization Defense
- Keep log frameworks up-to-date and disallow message lookups.
- Avoid native Java serialization (`ObjectInputStream.readObject()`) on untrusted data. Use Jackson or Kotlinx.serialization with polymorphism typing disabled (`DefaultTyping` restrictions).

## 2. Spring Security & Expression Language (SpEL)
- Never evaluate untrusted user strings with `SpelExpressionParser.parseExpression()`.
- Enforce method-level security (`@PreAuthorize("hasRole('ADMIN')")`) and verify resource tenant ownership in custom security evaluators.

## 3. XML External Entity (XXE) Prevention
- Always disable `DOCTYPE` declarations and external general entities when configuring `DocumentBuilderFactory` or `SAXParserFactory`.
