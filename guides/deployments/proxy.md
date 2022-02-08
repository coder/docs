---
title: Proxies
description: Learn how to configure forward and reverse proxies for Coder.
---

This article walks you through configuring proxies for Coder.

If your Coder installation accesses the internet through a forward proxy,
configure a [forward proxy](#forward-proxies).

If you have a reverse proxy in front of Coder, such as an ingress controller
internal to the cluster, then configure a [reverse proxy](#reverse-proxies).

## Forward proxies

Coder supports proxies for outbound HTTP and HTTPS connections once you've
configured the `coderd.proxy.http` and `coderd.proxy.https` settings in the
[Helm chart](../admin/helm-charts.md). These settings correspond to the standard
`http_proxy` and `https_proxy` environment variables, respectively.

If the proxy URL does not include a scheme, Coder defaults to treating it as
an HTTP proxy. It is also possible to connect to the proxy using HTTPS or SOCKS 5
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

For a [SOCKS 5 proxy](https://en.wikipedia.org/wiki/SOCKS) on port 1080,
use the setting:

```yaml
coderd:
  proxy:
    http: socks5://10.10.10.10:1080
```

If you specify a proxy for outbound HTTP connections, and you do not specify a proxy
for outgoing HTTPS connections, then Coder will proxy requests to HTTPS
endpoints using the HTTP proxy. The previous examples will proxy all requests through the defined proxy,
regardless of protocol (HTTP or HTTPS).

To configure a different proxy for use with outbound HTTPS connections, you can
specify the same proxy types (`http`, `https`, `socks5`) using the
`coderd.proxy.https` key.

For hosts that must connect directly, rather than using the proxy, define the
`exempt` setting with a comma-separated list of hosts and subdomains:

```yaml
coderd:
  proxy:
    # Coder will establish connections to cluster.local or example.com, or
    # their subdomains directly, rather than using the proxy settings.
    exempt: "cluster.local,example.com"
```

## Reverse proxies

If you have a reverse proxy in front of Coder, which is the case if you're using
an ingress controller, Coder receives connections originating from the proxy. For auditing, logging, and other features to correctly recognize the
connecting user's IP address information, you will need to configure the
`coderd.reverseProxy` setting.

> By default, Coder will ignore `X-Forwarded-For` and similar headers and remove
> them from proxied connections to [Dev URL
> services](../../workspaces/devurls.md). This prevents clients from spoofing
> their originating IP addresses.

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
