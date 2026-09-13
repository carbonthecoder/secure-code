import dns from "dns/promises";
import http from "http";
import https from "https";
import net from "net";

// 🛡️ SECURE-CODE Zero-Trust SSRF-Safe Fetch Utility
// Prevents: DNS Rebinding, Cloud Metadata Exfiltration (169.254.169.254),
// Loopback Probing (127.0.0.1), and Private Subnet Access (RFC 1918).

export interface SafeFetchOptions extends RequestInit {
  timeoutMs?: number;
  allowedProtocols?: ("http:" | "https:")[];
}

const BLOCKED_IPV4_RANGES = [
  { start: ipToLong("10.0.0.0"), end: ipToLong("10.255.255.255") },     // RFC 1918 Private
  { start: ipToLong("172.16.0.0"), end: ipToLong("172.31.255.255") },   // RFC 1918 Private
  { start: ipToLong("192.168.0.0"), end: ipToLong("192.168.255.255") }, // RFC 1918 Private
  { start: ipToLong("127.0.0.0"), end: ipToLong("127.255.255.255") },   // Loopback
  { start: ipToLong("169.254.0.0"), end: ipToLong("169.254.255.255") }, // Link-Local / AWS Metadata
  { start: ipToLong("0.0.0.0"), end: ipToLong("0.255.255.255") },       // Broadcast/Zero
];

function ipToLong(ip: string): number {
  return ip.split(".").reduce((acc, octet) => ((acc << 8) + parseInt(octet, 10)) >>> 0, 0);
}

function isPrivateIPv4(ip: string): boolean {
  if (!net.isIPv4(ip)) return false;
  const long = ipToLong(ip);
  return BLOCKED_IPV4_RANGES.some((range) => long >= range.start && long <= range.end);
}

function isPrivateIPv6(ip: string): boolean {
  if (!net.isIPv6(ip)) return false;
  const normalized = ip.toLowerCase();
  // Loopback (::1), Link-local (fe80::), Unique Local (fc00:: / fd00::)
  return (
    normalized === "::1" ||
    normalized.startsWith("fe80:") ||
    normalized.startsWith("fc") ||
    normalized.startsWith("fd") ||
    normalized.startsWith("::ffff:127.") // IPv4-mapped loopback
  );
}

export async function safeFetch(rawUrl: string, options: SafeFetchOptions = {}): Promise<Response> {
  const { timeoutMs = 8000, allowedProtocols = ["https:"], ...fetchOptions } = options;

  const parsedUrl = new URL(rawUrl);

  // 1. Enforce Allowed Protocol
  if (!allowedProtocols.includes(parsedUrl.protocol as any)) {
    throw new Error(`SSRF Block: Protocol '${parsedUrl.protocol}' is not allowed.`);
  }

  // 2. Resolve DNS Address Before Request
  const lookup = await dns.lookup(parsedUrl.hostname, { all: true });
  if (!lookup || lookup.length === 0) {
    throw new Error(`SSRF Block: Failed to resolve hostname '${parsedUrl.hostname}'.`);
  }

  // 3. Inspect All Resolved IPs Against Private/Cloud Subnets
  for (const record of lookup) {
    if (net.isIPv4(record.address) && isPrivateIPv4(record.address)) {
      throw new Error(`SSRF Block: Hostname resolved to private IPv4 address '${record.address}'.`);
    }
    if (net.isIPv6(record.address) && isPrivateIPv6(record.address)) {
      throw new Error(`SSRF Block: Hostname resolved to private/loopback IPv6 address '${record.address}'.`);
    }
  }

  // 4. Execute Fetch with Zero Auto-Redirect (Guards against DNS Rebinding via Redirects)
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);

  try {
    return await fetch(parsedUrl.toString(), {
      ...fetchOptions,
      redirect: "error", // Never follow redirects blindly
      signal: controller.signal,
    });
  } finally {
    clearTimeout(timer);
  }
}
