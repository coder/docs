---
title: "TypeError: Failed to fetch"
description: Learn how to resolve TypeError issues.
---

When using Coder, you may encounter this error when loading a workspace:

```console
Failed to fetch applications!
TypeError: Failed to fetch
```

## Why this happens

This is a WebSocket error that occurs when network traffic attempts to access
the applications endpoint.

## Troubleshooting Steps

- Ensure your Coder access URL is set to `https://your-coder-domain.com`.

  You can verify your access URL by going to **Admin** > **Infrastructure** >
  **Access URL**.

- Set `envproxy.accessURL` values to `https://your-coder-domanin.com/proxy` in
  the `values.yaml` file of your Coder Helm chart. Review our guide on [updating
  Helm charts](../admin/helm-charts.md) for more information on how to do this.

If none of these steps resolve the issue, please [contact
us](https://coder.com/contact) for further support.
