# C & C++ Stack: Performance Rules (secure-code)

## 1. Move Semantics & Copy Elimination
- Leverage C++11 move semantics (`std::move`) to transfer ownership of expensive resources rather than performing deep copies.
- Pass large read-only structs and objects by const reference (`const T&`) or `std::string_view` / `std::span`.

## 2. Memory Locality & Cache-Line Alignment
- Prefer contiguous storage (`std::vector`) over fragmented node-based containers (`std::list`).
- Align frequently accessed concurrent data structures to cache lines using `alignas(64)` to eliminate false sharing in multi-threaded code.
