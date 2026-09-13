# Mobile (Flutter, React Native, Swift, Kotlin) Stack: Security Rules (secure-code)

## 1. Secure Local Storage
- Never store API tokens, passwords, or encryption keys in plain `SharedPreferences` (Android) or `UserDefaults` (iOS).
- Use hardware-backed secure storage: EncryptedSharedPreferences / Android Keystore, iOS Keychain, or Flutter `flutter_secure_storage`.

## 2. SSL / TLS Certificate Pinning
- Enforce certificate or public key pinning for sensitive API calls to protect mobile users on compromised public Wi-Fi from man-in-the-middle (MITM) proxy interception.

## 3. Screen Obfuscation & Clipboard Protection
- Obfuscate sensitive screens (e.g. banking balances) when the app transitions to the background.
- Clear or auto-expire sensitive copied data (passwords, TOTP codes) from the clipboard within 60 seconds.
