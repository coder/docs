---
title: Admin password reset
description: Learn how to resolve issues with resetting your admin password.
---

When
[resetting your Coder admin password](../../admin/access-control/users/password-reset.md#resetting-the-site-admin-password)
in the terminal, you may encounter the following error:

```console
error: unable to upgrade connection: error dialing backend: remote error: tls:
handshake failure
```

## Why this happens

This upgrade-related error occurs when a proxy is in front of `kube-apiserver`,
blocking your attempt to reach the `coderd` pod and reset the admin password.

## Troubleshooting steps

To access the `coderd` pod properly, you'll need to remove the proxy. If
removing the proxy isn't possible, circumvent the proxy and make the call to
`coderd` directly using `kubectl`.

If this doesn't resolve the issue, please
[contact us](https://coder.com/contact) for further support.
