---
title: Docker in Environments
description: Learn how to enable support for secure Docker inside Environments.
---

If you're a site admin or a site manager, you can enable [container-based
virtual machines (CVMs)](../../environments/cvms.md) as an environment
deployment option. CVMs allow users to run system-level programs, such as Docker
and systemd, in their environments.

## Infrastructure Requirements

- CVMs leverage the [sysbox container
  runtime](https://github.com/nestybox/sysbox), so the Kubernetes Node must run
  a supported Linux distro with the minimum Kernel version (see [Sysbox Distro
  Compatibility](https://github.com/nestybox/sysbox/blob/master/docs/distro-compat.md)
  for more information)
- The cluster must allow privileged containers and `hostPath` mounts. Read more
  about why this is still secure [here](#security).

**Note:** Coder doesn't support legacy versions of cluster-wide proxy services
such as Istio.

## Enabling CVMs in Coder

1. Go to **Manage > Admin > Infrastructure**.
2. Toggle the **Enable Container-Based Virtual Machines** option to **Enable**.

## Setting Up Your Cluster

The following sections show how you can set up your K8 clusters hosted by Google,
Azure, and Amazon to support CVMs.

### Google Cloud Platform w/ GKE

To use CVMs with GKE, [create a cluster](../../setup/kubernetes/google.md) using
the following parameters:

- GKE Master version `>= 1.17`
- `node-version >= 1.17`
- `image-type = "UBUNTU"`

You can also provide `latest` instead of specific version numbers. For example:

```bash
gcloud beta container clusters create "YOUR_NEW_CLUSTER" \
    --node-version "latest" \
    --cluster-version "latest" \
    --image-type "UBUNTU"
    ...
```

### Azure Kubernetes Service

If you're using Kubernetes version 1.18, Azure defaults to the correct Ubuntu node
base image. When creating your cluster, set `--kubernetes-version` to `1.18.x`
or newer for CVMs.

### Amazon Web Services w/ EKS

You can modify an existing [AWS-hosted container](../../setup/kubernetes/aws.md)
to support CVMs by [creating a
nodegroup](https://eksctl.io/usage/managing-nodegroups/#creating-a-nodegroup-from-a-config-file)
and updating your `eksctl` config spec.

1. Define your config file in the location of your choice (we've named the file
   `coder-node.yaml`, but you can call it whatever you'd like):

    ```yaml
    apiVersion: eksctl.io/v1alpha5
    kind: ClusterConfig

    metadata: 
      version: "1.17"
      name: <YOUR_CLUSTER_NAME>
      region: <YOUR_AWS_REGION>

    nodeGroups:
    - name: coder-node-group
      amiFamily: Ubuntu1804
    ```

2. Create your nodegroup (be sure to provide the correct file name):

    ```bash
    eksctl create nodegroup --config-file=coder-node.yaml
    ```

## Security

The [Container-based Virtual Machine](../../environments/cvms.md) deployment
option leverages the [sysbox container
runtime](https://github.com/nestybox/sysbox) to offer a VM-like user experience
while retaining the footprint of a typical container.

Coder first launches a supervising container with additional privileges. This
container is standard and included with the Coder release package. During the
environment build process, the supervising container launches an inner container
using the [sysbox container runtime](https://github.com/nestybox/sysbox). This
inner container is the user’s [environment](../../environments/index.md).

The user cannot gain access to the supervising container at any point. The
isolation between the user's environment container and its outer, supervising
container is what provides [strong
isolation](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/security.md).

## Image Configuration

The following sections show how you can configure your image to include systemd
and Docker for use in CVMs.

### systemd

If your image's OS distribution doesn't link the `systemd` init to
`/sbin/init`, you'll need to do this manually in your Dockerfile.

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

When you start up an environment, Coder checks for the presence of `/sbin/init`
in your image. If it exists, then Coder uses it as the container entrypoint with
a `PID` of 1.

### Docker

To add Docker, install the `docker` packages into your image. For a
seamless experience, use [systemd](#systemd) and register the `docker` service
so `dockerd` runs automatically during initialization.

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
