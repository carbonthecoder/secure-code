import express, { Request, Response, NextFunction } from "express";
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import cors from "cors";
import crypto from "crypto";
import { z, ZodError } from "zod";

// 🛡️ SECURE-CODE Hardened Node.js / Express Production Server

const app = express();

// 1. Security Headers via Helmet
app.use(
  helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'"],
        styleSrc: ["'self'"],
        imgSrc: ["'self'", "data:", "https:"],
        objectSrc: ["'none'"],
        frameAncestors: ["'none'"],
        upgradeInsecureRequests: [],
      },
    },
    hsts: {
      maxAge: 63072000,
      includeSubDomains: true,
      preload: true,
    },
    frameguard: { action: "deny" },
    noSniff: true,
  })
);

// 2. Strict CORS Configuration (Dynamic Whitelist, No Wildcard with Credentials)
const ALLOWED_ORIGINS = new Set(["https://app.yourdomain.com", "https://admin.yourdomain.com"]);

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin || ALLOWED_ORIGINS.has(origin)) {
        callback(null, true);
      } else {
        callback(new Error("CORS Block: Origin not allowed by secure-code policy."));
      }
    },
    credentials: true,
    methods: ["GET", "POST", "PUT", "DELETE", "PATCH"],
    allowedHeaders: ["Content-Type", "Authorization", "X-API-Key"],
    maxAge: 86400, // Preflight cache for 24 hours
  })
);

// 3. Body Parsing with Strict Payload Size Limits (Anti-DDoS / Memory Exhaustion)
app.use(express.json({ limit: "100kb" }));
app.use(express.urlencoded({ extended: false, limit: "50kb" }));

// 4. Rate Limiting (Sliding Window)
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per window
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: "Too many requests, please try again later." },
});

app.use("/api/", apiLimiter);

// 5. Schema Validation Middleware Helper (Zero Mass Assignment)
function validateBody<T>(schema: z.ZodSchema<T>) {
  return (req: Request, res: Response, next: NextFunction) => {
    const result = schema.safeParse(req.body);
    if (!result.success) {
      return res.status(400).json({
        error: "Validation failed",
        details: result.error.errors.map((e) => ({ path: e.path.join("."), message: e.message })),
      });
    }
    req.body = result.data;
    next();
  };
}

// 6. Timing-Safe Auth Middleware
const EXPECTED_API_KEY = Buffer.from(process.env.API_KEY || "fallback-secret-minimum-32-chars-long", "utf8");

function requireApiKey(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers["x-api-key"];
  if (typeof authHeader !== "string") {
    return res.status(401).json({ error: "Missing X-API-Key header" });
  }

  const clientKey = Buffer.from(authHeader, "utf8");

  if (clientKey.length !== EXPECTED_API_KEY.length || !crypto.timingSafeEqual(clientKey, EXPECTED_API_KEY)) {
    return res.status(403).json({ error: "Invalid API Key" });
  }

  next();
}

// 7. Example Hardened Endpoint
const OrderSchema = z
  .object({
    productId: z.string().uuid(),
    quantity: z.number().int().min(1).max(50),
    currencyCents: z.bigint().or(z.number().int().positive()),
  })
  .strict();

app.post("/api/orders", requireApiKey, validateBody(OrderSchema), (req: Request, res: Response) => {
  res.status(201).json({ status: "created", order: req.body });
});

// 8. Global Fail-Safe Error Handler (No Stack Trace Leakage in Production)
app.use((err: any, req: Request, res: Response, next: NextFunction) => {
  const isProd = process.env.NODE_ENV === "production";
  console.error(`[ERROR] ${req.method} ${req.path}:`, err.message);

  res.status(err.status || 500).json({
    error: isProd ? "Internal Server Error" : err.message,
    ...(isProd ? {} : { stack: err.stack }),
  });
});

export default app;
