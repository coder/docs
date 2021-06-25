---
title: "TypeError: Failed to fetch"
description: Learn how to resolve the TypeError
---

When using Coder, you may encounter the following error when loading a workspace:

```console
Failed to fetch applications!
TypeError: Failed to fetch
```

## Why this happens

This is a websocket error that occurs when network traffic attempts to access
the applications' endpoint.

## Troubleshooting Steps

- Ensure your Coder access URL is set to `https://your-coder-domain.com`

    1. To find the access URL, navigate to **Admin** > **Infrastructure** >
    **Access URL**

- If not already done so, set your `envproxy.accessURL` values to `https://your-coder-domanin.com/proxy`
in the `values.yaml` file of your Coder Helm chart.

If none of these steps resolve the issue, please [contact us](https://coder.com/contact)
for further support.
