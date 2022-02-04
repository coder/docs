---
title: Proxies
description: Learn how to configure forward and reverse proxies for Coder.
---

If your Coder installation will access the Internet through a forward proxy, see
the reference for configuring [Forward proxies](#forward-proxies).

If you have a reverse proxy in front of Coder, such as an Ingress Controller
internal to the cluster, then see the reference for configuring
[Reverse proxies](#reverse-proxies).

## Forward proxies

Coder supports proxies for outbound HTTP and HTTPS connections by configuring
the `coderd.proxy.http` and `coderd.proxy.https` settings in the Helm chart,
which correspond to the standard `http_proxy` and `https_proxy` environment
variables, respectively.

If the proxy URL does not include a scheme, Coder will default to treating it as
an HTTP proxy. It is also possible to connect to the proxy using HTTPS or SOCKS5
protocols.

For an HTTP proxy with address `http://localhost:3128`, use the setting:

```yaml
coderd:
  proxy:
    http: localhost:3128
```

For an HTTPS proxy with address `https://localhost:3128`, include the scheme:

```yaml
coderd:
  proxy:
    http: https://localhost
```

For a [SOCKS 5 proxy](https://en.wikipedia.org/wiki/SOCKS) with on port 1080,
use the setting:

```yaml
coderd:
  proxy:
    http: socks5://10.10.10.10:1080
```

If you specify a proxy for outbound HTTP connections and do not specify a proxy
for outgoing HTTPS connections, then Coder will proxy requests to HTTPS
endpoints using the HTTP proxy. The previous examples will proxy all requests,
regardless of protocol (HTTP or HTTPS), through the defined proxy.

To configure a different proxy to use for outbound HTTPS connections, you may
specify the same proxy types (`http`, `https`, `socks5`) using the
`coderd.proxy.https` key.

For hosts that must connect directly, rather than using the proxy, define the
`exempt` setting with a comma-separated list of hosts and subdomains:

```yaml
coderd:
  proxy:
    # Coder will establish connections to cluster.local or example.com, or
    # their subdomains, directly, rather than using the proxy settings.
    exempt: "cluster.local,example.com"
```

## Reverse proxies

If you have a reverse proxy in front of Coder, as will be the case when you are
using an Ingress Controller, Coder will receive connections originating from the
proxy. In order for auditing, logging, and other features to associate the
connecting user's IP address information correctly, you will need to configure
the `coderd.reverseProxy` setting.

By default, to prevent clients from spoofing their originating IP addresses
using the `X-Forwarded-For` or similar headers, Coder will ignore all such
headers and remove them from proxied connections to
[Dev URL services](../../workspaces/devurls.md).

Specify a list of trusted origin addresses (those of the reverse proxy) in CIDR
format as follows:

```yaml
coderd:
  reverseProxy:
    # These settings will treat inbound connections originating from
    # localhost (127.0.0.1/8) and the RFC 1918 Class A network (10.0.0.0/8)
    # as trusted proxies, and will consider the configured headers.
    trustedOrigins:
      - 127.0.0.1/8
      - 10.0.0.0/8

    headers:
      - X-Forwarded-For
```
