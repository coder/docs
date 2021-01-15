---
title: Docker in Environments
description: Learn how to enable support for secure Docker inside Environments.
state: alpha
---

As a platform administrator, you have the option to enable
[Container-based Virtual Machines](../../environments/cvms.md) as an Environment
deployment option. This option allows users to run system-level
programs inside their Environment including Docker and systemd.

Navigate to **Manage > Admin > General** to enable this option.

## Infrastructure Requirements

- The Kubernetes Nodes must have a minimum kernel version of `5.4`
  (released Nov 24th, 2019).
- The Kubernetes Nodes must be running an Ubuntu OS.
- Legacy versions of cluster-wide proxy services such as Istio are not
  supported.
- The cluster must allow privileged containers and `hostPath` mounts. Read more
  about why this is still secure [here](#security).

## Security

The [Container-based Virtual Machine](../../environments/cvms.md) deployment
option leverages the [sysbox container runtime](https://github.com/nestybox/sysbox)
to offer a VM-like user experience with the footprint of a typical container.

Coder first launches a supervising container with privileged. This container is
standard and included as part of the Coder release package. As part of the
Environment build process, the supervising container launches an inner container
using the [sysbox container runtime](https://github.com/nestybox/sysbox).
This inner container is the user’s [Environment](../../environments/index.md).
The user cannot gain access to the supervising container at any point during the
lifecycle of their Environment. The isolation between the user’s Environment
container and it’s outer, supervising container is what provides
[strong isolation](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/security.md).

## Image Configuration

### systemd

During Environment startup, Coder checks for the presence of `/sbin/init` within
the Environment Image. If the file exists, it's used as the container entrypoint
with a `PID` of 1. If your image OS distribution does not link the `systemd`
init to `/sbin/init`, you'll need to do this manually in your Dockerfile.

The following snippet demonstrates how an image can specify `systemd` as the
init.

```Dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y \
    build-essential \
    systemd

# use systemd as the init
RUN ln -s /lib/systemd/systemd /sbin/init
```

### Adding Docker

Be sure to install the `docker` packages into your Environment Image. For a
seamless experience, use [systemd](#systemd) and register the `docker` service
so `dockerd` is automatically run during initialization.

The following snippet demonstrates how an image can register the `docker`
service in its Dockerfile.

```Dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    bash \
    docker.io \
    curl \
    sudo \
    systemd

# Enables Docker starting with systemd
RUN systemctl enable docker

# use systemd as the init
RUN ln -s /lib/systemd/systemd /sbin/init
```
