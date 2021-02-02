---
title: "SSH Configuration"
description: Learn how to configure SSH access to Coder environments.
---

By default, Coder enables SSH access for all users. Each user has a single
private key which provides access to all of their enviornments.

As part of the standard Coder envionrment asset bundle, a lightweight SSH
server is mounted into he enviornment agent and used as a backup when no server
is found on port 22. This allows slimmer images to
remain accessible by SSH without any image dependencie. The built-in server
is limited, and does not properly implement more advaned usages of SSH like
X11-forwarding and `sshd_config` specifications.

If SSH is the primary mode of access for your users, consider running a full
OpenSSH server with `systemd` inside your image instead.

## OpenSSH

> If a running TCP server is
detected on port 22, incoming SSH traffic is forwarded to this server.

```Dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y \
    build-essential \
    systemd
    openssh-server

# Start OpenSSH with systemd
RUN systemctl enable ssh
```

At startup, Coder injects the user's SSH key into `~/authorized_keys` to allow
proper authentication behavior from OpenSSH. For the most consitent experience,
add the following to the `/etc/ssh/sshd_config` file in your Dockerfile.

```text
PermitUserEnvironment yes
X11Forwarding yes
X11UseLocalhost no
```

## Disable SSH Access

If you would like to disable SSH access, either:

- Run `helm install --set ssh.enable=false`
- Add the following to your values override file and run `helm install -f values.yaml`

```yaml
ssh:
  enable: false
```

> **For Cloudflare Users:** Cloudflare's **proxied** mode does _not_ support
> SSH. If you're using Cloudflare for SSL, add your certificates to your cluster
> and use the **DNS only** mode to allow SSH.
