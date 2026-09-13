# C & C++ Stack: Security Rules (secure-code)

## 1. Memory Safety & Buffer Bounds Checking
- Ban unsafe C-string functions: `strcpy`, `strcat`, `sprintf`, `gets`. Use bounded alternatives: `strncpy`, `snprintf`, or `std::string_view` / `std::string`.
- Ensure all array and vector index accesses are bounds-checked (`vec.at(index)` or explicit `index < vec.size()`).

## 2. Dynamic Analysis & Sanitizers
- Compile and test with AddressSanitizer (`-fsanitize=address`) and UndefinedBehaviorSanitizer (`-fsanitize=undefined`).
- Enable stack protector flags: `-fstack-protector-strong -D_FORTIFY_SOURCE=2`.

## 3. Resource Management (RAII)
- Use RAII with smart pointers (`std::unique_ptr`, `std::shared_ptr`) to eliminate double-free, use-after-free, and memory leaks. Avoid manual `malloc`/`free` or raw `new`/`delete`.
