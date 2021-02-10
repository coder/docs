---
title: "Dev URLs"
description: Learn how to configure Dev URL support for a Coder deployment.
---

Developer (Dev) URLs allow users to access the ports of services they are
developing within their environment. However, before individual developers can
set up Dev URLs, an administrator must configure and enable Dev URL usage.

## Before You Proceed

You must own a wildcard DNS record for your custom domain name to enable and use
Dev URLs with Coder.

## Enabling the Use of Dev URLs

[Dev URLs](../environments/devurls.md) is an opt-in feature. To enable Dev URLs
in your cluster, you'll need to modify your:

1. Helm Chart
2. Wildcard DNS record

### Step 1: Modify the Helm Chart

Set `devurls.host` to a wildcard domain pointing to your ingress controller:

```shell
helm upgrade coder coder/coder --set devurls.host="*.my-custom-domain.io"
```

If you're using the default ingress controller, specifying a value for
`devurls.host` automatically adds a rule that routes Dev URL requests to the
user's environment:

```yaml
 - host: "*.my-custom-domain.io"
    http:
      paths:
      - path: /
        backend:
          serviceName: envproxy
          servicePort: 8080
```

If you are providing your own ingress controller, then you will need to add the
rule manually.

### Step 2: Modify the Wildcard DNS Record

The final step to enabling Dev URLs is to update your wildcard DNS record. Get
the **ingress IP address** using `kubectl --namespace coder get ingress` and
point your wildcard DNS record (e.g., \*.my-custom-domain.io) to the ingress IP
address.
