---
title: Docker in workspaces
description: Learn about supproting Docker inside workspaces.
---

If you're a site admin or a site manager, you can enable
[container-based virtual machines (CVMs)](../../../workspaces/cvms.md) as a
workspace deployment option. CVMs allow users to run system-level programs, such
as Docker and systemd, in their workspaces.

## Infrastructure requirements

- CVMs leverage the
  [Sysbox container runtime](https://github.com/nestybox/sysbox), so the
  Kubernetes Node must run a supported Linux distro with the minimum kernel
  version (see
  [Sysbox distro compatibility](https://github.com/nestybox/sysbox/blob/master/docs/distro-compat.md)
  for more information)
- The cluster must allow privileged containers and `hostPath` mounts. Read more
  about why this is still secure [here](#security).

> You can use any cloud provider that supports the above requirements, but we
> have instructions on how to set up supported clusters on
> [AWS](../../setup/kubernetes/aws.md) and
> [Google](../../setup/kubernetes/google.md). Azure-hosted clusters will meet
> these requirements as long as you use Kubernetes version 1.18+.
>
> Coder doesn't support legacy versions of cluster-wide proxy services such as
> Istio, and CVMs do not currently support NFS as a file system.

## Security

The [Container-based virtual machine](../../../workspaces/cvms.md) deployment
option leverages the
[Sysbox container runtime](https://github.com/nestybox/sysbox) to offer a
VM-like user experience while retaining the footprint of a typical container.

Coder first launches a supervising container with additional privileges. This
container is standard and included with the Coder release package. During the
workspace build process, the supervising container launches an inner container
using the [Sysbox container runtime](https://github.com/nestybox/sysbox). This
inner container is the user’s [workspace](../../../workspaces/index.md).

The user cannot gain access to the supervising container at any point. The
isolation between the user's workspace container and its outer, supervising
container is what provides
[strong isolation](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/security.md).

## Known issues

NVIDIA GPUs can be added to CVMs on bare metal clusters only. This feature is
not supported on Google Kubernetes Engine or other cloud providers at this time.

Support for NVIDIA [GPUs](../gpu-acceleration.md) is in **beta**. We do not support
AMD GPUs at this time.

## Next Steps

- [Set up a Kubernetes cluster](cluster-setup.md) for Coder that's capable of
  hosting CVMs
- Learn [how to work with images](images.md) for use with CVMs
- Learn [how to enable CVMs for users](management.md)
