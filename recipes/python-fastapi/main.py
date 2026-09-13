from fastapi import FastAPI, Depends, HTTPException, Security, status, Request
from fastapi.security import APIKeyHeader
from pydantic import BaseModel, Field, ConfigDict
from typing import Annotated
import hmac
import os
import time

app = FastAPI(title="secure-code Hardened FastAPI API")

API_KEY_HEADER = APIKeyHeader(name="X-API-Key", auto_error=False)
EXPECTED_API_KEY = os.getenv("API_KEY", "prod-secret-fallback-for-typing").encode()

# 🛡️ 1. Pydantic v2 Strict Input Schema (No Mass Assignment, No Parameter Injection)
class CreateItemRequest(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    title: str = Field(..., min_length=1, max_length=100)
    description: str | None = Field(default=None, max_length=500)
    price_in_cents: int = Field(..., ge=0, description="Price in integer cents, zero float drift")

# 🛡️ 2. Constant-Time Authentication (Eliminates Timing Attacks)
async def verify_api_key(api_key: Annotated[str | None, Security(API_KEY_HEADER)]):
    if not api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing API Key header"
        )
    # Constant-time comparison
    if not hmac.compare_digest(api_key.encode(), EXPECTED_API_KEY):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid credentials"
        )
    return True

# 🛡️ 3. Security Headers Middleware
@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    start_time = time.perf_counter()
    response = await call_next(request)
    duration_ms = (time.perf_counter() - start_time) * 1000

    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["Strict-Transport-Security"] = "max-age=63072000; includeSubDomains"
    response.headers["Server-Timing"] = f"total;dur={duration_ms:.2f}"
    return response

@app.post("/items", dependencies=[Depends(verify_api_key)])
async def create_item(payload: CreateItemRequest):
    return {"status": "created", "item": payload.model_dump()}
