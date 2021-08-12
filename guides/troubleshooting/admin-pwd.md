---
title: Resetting admin password
description: Learn how to resolve errors resetting your admin password
---

When attempting to reset your Coder admin password in the terminal, you may
encounter the following error:

```console
error: unable to upgrade connection: error dialing backend: remote error: tls:
handshake failure
```

## Why this happens

This upgrade error can occur when a proxy is in front of the `kube-apiserver`,
which blocks your attempt to reach the `coderd` pod and reset the admin
password.

## Troubleshooting steps

To properly access to the `coderd` pod, you'll need to either remove the proxy
(if possible), or circumvent the proxy and make the call directly with `kubectl`.

If this doesn't resolve the issue, please
[contact us](https://coder.com/contact) for further support.
