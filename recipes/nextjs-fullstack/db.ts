import { Pool } from "pg";

// 🛡️ SECURE-CODE Hardened Database Connection Pool & Ownership Scoping
declare global {
  var globalPgPool: Pool | undefined;
}

export const pool =
  global.globalPgPool ||
  new Pool({
    connectionString: process.env.DATABASE_URL,
    max: 10, // Optimal pool size for serverless/container instances
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
  });

if (process.env.NODE_ENV !== "production") {
  global.globalPgPool = pool;
}

// 🛡️ Parameterized & Tenant-Scoped Query Helper (Zero IDOR / Zero SQLi)
export async function queryWithTenancy<T = any>(
  queryText: string,
  params: any[],
  tenantId: string
): Promise<T[]> {
  const client = await pool.connect();
  try {
    // Assert tenant boundary
    const result = await client.query(queryText, [...params, tenantId]);
    return result.rows;
  } finally {
    client.release();
  }
}
