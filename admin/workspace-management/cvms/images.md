---
title: Images
description: Learn how to work with images for CVM-enabled workspaces.
---

This article walks you through how to configure images for use with CVMs, as
well as how to access images located in private registries.

## Image configuration

The following sections show how you can configure your image to include systemd
and Docker for use in CVMs.

### systemd

If your image's OS distribution doesn't link the `systemd` init to `/sbin/init`,
you'll need to do this manually in your Dockerfile.

The following snippet shows how you can specify `systemd` as the init in your
image:

```Dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y \
    build-essential \
    systemd

# use systemd as the init
RUN ln -s /lib/systemd/systemd /sbin/init
```

When you start up a workspace, Coder checks for the presence of `/sbin/init` in
your image. If it exists, then Coder uses it as the container entrypoint with a
`PID` of 1.

### Docker

To add Docker, install the `docker` packages into your image. For a seamless
experience, use [systemd](#systemd) and register the `docker` service so
`dockerd` runs automatically during initialization.

The following snippet shows how your image can register the `docker` services in
its Dockerfile.

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

## Private registries

To use CVM workspaces with private images, you **must** create a
[registry](../registries/index.md#adding-a-registry) with authentication
credentials. Private images that can be pulled directly by the node will not
work with CVMs.

This restriction is removed if you enable [cached CVMs](#enabling-cached-cvms).
