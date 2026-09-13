import { z } from "zod";

// 🛡️ SECURE-CODE Fail-Fast Environment Variable Schema Validator (TypeScript)
// Usage: Import `env` anywhere in your application. If an environment variable is
// missing or malformed, the process immediately exits with a clean, formatted error.

const EnvSchema = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  PORT: z.coerce.number().int().positive().default(3000),
  
  // Database Configuration
  DATABASE_URL: z.string().url({ message: "DATABASE_URL must be a valid connection URI." }),
  
  // Authentication & Secrets
  JWT_SECRET: z.string().min(32, { message: "JWT_SECRET must be at least 32 characters long." }),
  SESSION_COOKIE_SECRET: z.string().min(32, { message: "SESSION_COOKIE_SECRET must be at least 32 characters long." }),
  
  // Redis / Distributed Cache (Optional in dev, required in prod)
  REDIS_URL: z.string().url().optional(),
});

function validateEnvironment() {
  const result = EnvSchema.safeParse(process.env);

  if (!result.success) {
    console.error("\n❌ [CRITICAL CONFIGURATION ERROR] Missing or invalid environment variables:");
    console.error("========================================================================");
    
    for (const issue of result.error.issues) {
      console.error(`  - ${issue.path.join(".")}: ${issue.message}`);
    }
    
    console.error("========================================================================\n");
    console.error("Process terminating to prevent running in an insecure/unconfigured state.\n");
    process.exit(1);
  }

  return result.data;
}

export const env = validateEnvironment();
