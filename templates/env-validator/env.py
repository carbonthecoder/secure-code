import sys
from pydantic import Field, PostgresDsn, SecretStr, ValidationError
from pydantic_settings import BaseSettings, SettingsConfigDict

# 🛡️ SECURE-CODE Fail-Fast Environment Variable Schema Validator (Python)
# Usage: from .env import settings
# If any required configuration is missing, process crashes immediately with a clean error report.

class AppSettings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore"
    )

    ENVIRONMENT: str = Field(default="development")
    PORT: int = Field(default=8000, ge=1, le=65535)

    # Database
    DATABASE_URL: str = Field(..., description="PostgreSQL connection URI")

    # Cryptographic Secrets (Masked in logs via SecretStr)
    SECRET_KEY: SecretStr = Field(..., min_length=32, description="Application secret key (>= 32 chars)")
    JWT_SECRET: SecretStr = Field(..., min_length=32, description="JWT signing secret (>= 32 chars)")

    # Redis Cache (Optional)
    REDIS_URL: str | None = Field(default=None)

try:
    settings = AppSettings()
except ValidationError as e:
    print("\n❌ [CRITICAL CONFIGURATION ERROR] Missing or invalid environment variables:", file=sys.stderr)
    print("========================================================================", file=sys.stderr)
    for err in e.errors():
        field = ".".join(str(loc) for loc in err["loc"])
        print(f"  - {field}: {err['msg']}", file=sys.stderr)
    print("========================================================================\n", file=sys.stderr)
    print("Process terminating to prevent running in an insecure/unconfigured state.\n", file=sys.stderr)
    sys.exit(1)
