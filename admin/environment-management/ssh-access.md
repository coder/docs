---
title: "Disable SSH Access"
description: Learn how to disable SSH to comply with ingress restrictions.
---

By default, Coder enables SSH access for all users. There are no additional
dependencies required.

## Disable SSH Access

If you would like to disable SSH access, either:

- Run `helm install --set ssh.enable=false`
- Add the following to your values override file and run `helm install -f
  values.yaml`

```yaml
ssh:
  enable: false
```

> **For Cloudflare Users:** Cloudflare's **proxied** mode does *not* support
> SSH. If you're using Cloudflare for SSL, add your certificates to your cluster
> and use the **DNS only** mode to allow SSH.
