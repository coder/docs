---
title: "SSH Configuration"
description: Learn how to configure SSH access to Coder environments.
---

By default, Coder enables SSH access for all users. Coder assigns each user a
private key that they can use to access their environments.

## Background

Part of the standard Coder environment asset bundle is a lightweight SSH server
mounted onto the environment agent; the lightweight SSH server is a backup used
when Coder can't find a server available on port 22. This allows slimmer images
to remain accessible via SSH without the need for additional image dependencies.

## Using OpenSSH

The built-in SSH server is limited and does not correctly implement
advanced functionality like X11 forwarding or `sshd_config` specifications. As
such, f SSH is the primary mode of access to Coder for your users, consider
running a full OpenSSH server with `systemd` inside your image instead.

To do so:

1. Make sure that you're creating your environments with the [CVM
   option](https://coder.com/docs/environments/cvms) enabled
2. Add the following to your Dockerfile:

```Dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y \
    build-essential \
    systemd \
    openssh-server

# Start OpenSSH with systemd
RUN systemctl enable ssh
```

> If Coder detects a running TCP server on port 22, it will forward incoming SSH
> traffic to this server.

At startup, Coder injects the user's SSH key into `~/authorized_keys` to
faciliate authentication with OpenSSH. For the best experience, add the
following to your `/etc/ssh/sshd_config` file as well:

```text
PermitUserEnvironment yes
X11Forwarding yes
X11UseLocalhost no
```

## Disable SSH Access

If you would like to disable SSH access, you can either:

- Run `helm install --set ssh.enable=false`
- Add the following to your helm chart and run `helm install -f values.yaml`

```yaml
ssh:
  enable: false
```

> **For Cloudflare Users:** Cloudflare's **proxied** mode does _not_ support
> SSH. If you're using Cloudflare for SSL, add your certificates to your cluster
> and use the **DNS only** mode to allow SSH.
