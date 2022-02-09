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

If the proxy URL does not include a scheme, Coder defaults to treating it as an
HTTP proxy. Coder also supports proxies using HTTPS or SOCKS 5 protocols. As a
special case, Coder will always establish connections to `localhost` directly,
regardless of the `coderd.proxy.exempt` setting. For additional proxy setting
information, see the [documentation for ProxyFromEnvironment].

[documentation for proxyfromenvironment]:
  https://pkg.go.dev/net/http#ProxyFromEnvironment

For an HTTP proxy with address `http://localhost:3128`, use the setting:

```yaml
coderd:
  proxy:
    # If the scheme is omitted, Coder will default to `http`
    http: localhost:3128
```

For an HTTPS proxy with address `https://localhost`, include the scheme:

```yaml
coderd:
  proxy:
    # If the port is omitted, Coder will use the default port corresponding to
    # the selected scheme (443 for https)
    http: https://localhost
```

For a [SOCKS 5 proxy](https://en.wikipedia.org/wiki/SOCKS) on listening on port
1080, use the setting:

```yaml
coderd:
  proxy:
    http: socks5://10.10.10.10:1080
```

If you specify a proxy for outbound HTTP connections, and you do not specify a
proxy for outgoing HTTPS connections, then Coder will proxy requests to HTTPS
endpoints using the HTTP proxy. The previous examples will proxy all requests
through the defined proxy, regardless of protocol (HTTP or HTTPS).

To configure a different proxy for use with outbound HTTPS connections, you can
specify the same proxy types (`http`, `https`, `socks5`) using the
`coderd.proxy.https` key:

```yaml
coderd:
  proxy:
    # Use an HTTP proxy on port 3128 for outbound HTTP connections, and an
    # HTTP proxy on port 8080 for outbound HTTPS connections.
    http: http://localhost:3128
    https: http://localhost:8080
```

For hosts that must connect directly, rather than using the proxy, define the
`coderd.proxy.exempt` setting with a comma-separated list of hosts and
subdomains:

```yaml
coderd:
  proxy:
    # Coder will establish connections to cluster.local or example.com, or
    # their subdomains directly, rather than using the proxy settings.
    exempt: "cluster.local,example.com"
```

## Reverse proxies

If you have a reverse proxy in front of Coder, which is the case if you're using
an ingress controller, Coder receives connections originating from the proxy.
For auditing, logging, and other features to correctly recognize the connecting
user's IP address information, you will need to configure the
`coderd.reverseProxy` setting.

> By default, Coder will ignore `X-Forwarded-For` and similar headers and remove
> them from proxied connections to [Dev URL services]. This prevents clients
> from spoofing their originating IP addresses.

[dev url services]: ../../workspaces/devurls.md

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
