import socket
import ipaddress
import urllib.parse
import urllib.request
import urllib.error

# 🛡️ SECURE-CODE Zero-Trust SSRF-Safe Fetch Utility for Python
# Validates resolved IP addresses against private networks before connection.

BLOCKED_NETWORKS = [
    ipaddress.ip_network("10.0.0.0/8"),
    ipaddress.ip_network("172.16.0.0/12"),
    ipaddress.ip_network("192.168.0.0/16"),
    ipaddress.ip_network("127.0.0.0/8"),
    ipaddress.ip_network("169.254.0.0/16"),  # AWS / Cloud Metadata
    ipaddress.ip_network("0.0.0.0/8"),
    ipaddress.ip_network("::1/128"),        # IPv6 Loopback
    ipaddress.ip_network("fc00::/7"),       # IPv6 Unique Local
    ipaddress.ip_network("fe80::/10"),      # IPv6 Link-Local
]

class SSRFSecurityException(Exception):
    pass

def safe_fetch(url: str, timeout_seconds: float = 8.0) -> bytes:
    parsed = urllib.parse.urlparse(url)

    # 1. Enforce HTTPS / HTTP Protocol
    if parsed.scheme not in ("https", "http"):
        raise SSRFSecurityException(f"Forbidden protocol scheme: {parsed.scheme}")

    hostname = parsed.hostname
    if not hostname:
        raise SSRFSecurityException("Invalid URL: missing hostname")

    # 2. Resolve DNS Address Before Request
    try:
        addr_info = socket.getaddrinfo(hostname, parsed.port or (443 if parsed.scheme == "https" else 80))
    except socket.gaierror as e:
        raise SSRFSecurityException(f"DNS resolution failure for {hostname}: {e}")

    # 3. Validate Every Resolved IP Address
    for family, _, _, _, sockaddr in addr_info:
        ip_str = sockaddr[0]
        ip_obj = ipaddress.ip_address(ip_str)

        for blocked in BLOCKED_NETWORKS:
            if ip_obj in blocked:
                raise SSRFSecurityException(
                    f"SSRF Alert: Hostname {hostname} resolved to protected private/cloud IP: {ip_str}"
                )

    # 4. Open Request with Redirect Disallowed (Anti-DNS Rebinding)
    class NoRedirectHandler(urllib.request.HTTPRedirectHandler):
        def redirect_request(self, req, fp, code, msg, headers, newurl):
            raise SSRFSecurityException("SSRF Alert: HTTP redirects are strictly disallowed.")

    opener = urllib.request.build_opener(NoRedirectHandler)
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "secure-code-safe-fetch/1.0"}
    )

    with opener.open(req, timeout=timeout_seconds) as response:
        return response.read()
