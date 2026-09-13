# Mobile (Flutter, React Native, Swift, Kotlin) Stack: Performance Rules (secure-code)

## 1. 60 / 120 FPS Main Thread Preservation
- Never perform JSON parsing, disk I/O, or image processing on the UI/Main thread.
- In Flutter: Use `compute(isolateFunction, data)`.
- In React Native: Offload heavy calculations to TurboModules or Native Modules.
- In Swift: Dispatch heavy work to `DispatchQueue.global(qos: .userInitiated)`.

## 2. Image Decoding & Memory Footprint
- Never load unconstrained full-resolution photos into mobile memory. Downsample and decode images to the exact target display resolution before rendering.
- Recycle image memory in list view cells.

## 3. Battery & Background Task Throttling
- Batch network requests and defer non-critical sync operations to Wi-Fi/charging periods using WorkManager (Android) or BGTaskScheduler (iOS).
