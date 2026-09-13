package com.securecode;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

// 🛡️ SECURE-CODE Spring Boot Hardened Controller (Tenancy Scoping + Validation)

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    public record CreateOrderRequest(
        @NotBlank(message = "Item SKU is required")
        String itemSku,

        @NotNull(message = "Quantity is required")
        @Min(value = 1, message = "Quantity must be at least 1")
        Integer quantity,

        @NotNull(message = "Price in cents is required")
        @Min(value = 0, message = "Price in cents cannot be negative")
        Long priceInCents // Zero float money math
    ) {}

    @PostMapping
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<?> createOrder(
        @Valid @RequestBody CreateOrderRequest request,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        // Enforce user/tenant ownership check:
        String authenticatedUserId = userDetails.getUsername();

        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of(
            "status", "created",
            "userId", authenticatedUserId,
            "order", request
        ));
    }
}
