---
title: "SSH configuration"
description: Learn how to configure SSH access to Coder workspaces.
---

By default, Coder enables SSH access for all users. Coder assigns each user a
private key that they can use to access their workspaces.

## Background

Part of the standard Coder workspace asset bundle is a lightweight SSH server
mounted onto the workspace agent; the lightweight SSH server is a backup used
when Coder can't find a server available on port 22. This allows slimmer images
to remain accessible via SSH without the need for additional image dependencies.

## Using OpenSSH

The built-in SSH server is limited and does not implement advanced functionality
like X11 forwarding or `sshd_config` specifications. If SSH is the primary mode
of access to Coder for your users, consider running an entire OpenSSH server
with `systemd` inside your image instead.

To do so, add the following to your Dockerfile:

```Dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y \
    build-essential \
    systemd \
    openssh-server

# Start OpenSSH with systemd
RUN systemctl enable ssh

# recommended: remove the system-wide environment override
RUN rm /etc/environment

# recommended: adjust OpenSSH config
RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config && \
  echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
  echo "X11UseLocalhost no" >> /etc/ssh/sshd_config
```

Then, make sure that you're creating your workspaces with the
[CVM option](../../workspaces/cvms.md) enabled.

> If Coder detects a running TCP server on port 22, it will forward incoming SSH
> traffic to this server. This means that workspaces should not run a TCP server
> on port 22 unless it can adequately handle incoming SSH traffic.

At startup, Coder injects the user's SSH key into `~/authorized_keys` inside
your workspace to facilitate authentication with OpenSSH. For the best
experience, add the following to your `/etc/ssh/sshd_config` file inside your
image:

```text
PermitUserEnvironment yes
X11Forwarding yes
X11UseLocalhost no
```

> X11 forwarding will fail with `X11 forwarding request failed on channel 0` if
> `xauth` is not installed.

### SSH environment variables

OpenSSH handles environment variables differently than most container processes.
Environment variable overrides for OpenSSH sessions are set by
`~/.ssh/environment` and `/etc/environment`. Note that these values will
override those specified in the Dockerfile `ENV` directives.

At workspace startup, Coder injects the image defined environment variables into
`~/.ssh/environment`, as well as a set of Coder-defined defaults.

The following snippet shows an example of what this file may look like for a new
workspace.

```text
# --------- START CODER ENVIRONMENT VARIABLES ----------
# The following has been auto-generated at workspace startup
# You should not hand-edit this section unless you are deleting it.

SHELL=/bin/bash
CODER_USER_EMAIL=email@coder.com
CODER_WORKSPACE_NAME=dev
HOSTNAME=dev
CODER_USERNAME=john
SSH_AUTH_SOCK=/home/coder/.coder-ssh-agent.sock
PWD=/home/coder
CODER_ASSETS_ROOT=/var/tmp/coder
HOME=/home/coder
LANG=en_US.UTF-8
CODER_CPU_LIMIT=24.00
CODER_MEMORY_LIMIT=32.00
USER=coder
ITEM_URL=https://coder.domain.com/extensions
CODER_IMAGE_TAG=latest
CODER_IMAGE_DIGEST=sha256:1586122346e7d9d64a0c49a28df7538de4c5da5bfe0df672b1552dd52932c9a7
SERVICE_URL=https://extensions.coder.com/api
CODER_IMAGE_URI=codercom/enterprise-base:ubuntu
PATH=/usr/local/google-cloud-sdk/bin:/home/coder/go/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/tmp/coder/coder-cli
BASE_PATH=/proxy/workspaces/60162f9e-78809dfc9a9e24b8f5e580ff/ide
_=/var/tmp/coder/envagent

# ----------------- END CODER -----------------------
```

## Disable SSH access

If you would like to disable SSH access:

1. Log into the Coder UI with a site manager account, and go to **Manage** >
   **Providers**.
1. Select the workspace provider where you want to disable SSH. Click on the
   **vertical ellipses** to its right and select **edit**.
1. Scroll down to the **Features** section and toggle **External Connect** to
   **off**.

Repeat these steps for each workspace provider where you want to disable SSH
connections.
