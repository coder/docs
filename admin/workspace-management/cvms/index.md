---
title: Docker in workspaces
description: Learn about supproting Docker inside workspaces.
---

[Container-based virtual machines (CVMs)](../../../workspaces/cvms.md) allow
users to run system-level programs, such as Docker and systemd, in their
workspaces.

If you're a site admin or a site manager, you can enable CVMs as a workspace
deployment option.

## Infrastructure requirements

- CVMs leverage the
  [Sysbox container runtime](https://github.com/nestybox/sysbox), so the
  Kubernetes Node must run a supported Linux distro with the minimum kernel
  version. See
  [Sysbox distro compatibility](https://github.com/nestybox/sysbox/blob/master/docs/distro-compat.md)
  and
  [Sysbox User Guide: Design Notes](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/design.md)
  for more information.

- The cluster must allow privileged containers and `hostPath` mounts. See
  [Security](#security) for more information on why this is still secure.

> You can use any cloud provider that supports the above requirements, but we
> have instructions on how to set up supported clusters on
> [AWS](../../../setup/kubernetes/aws.md) and
> [Google](../../../setup/kubernetes/google.md). Azure-hosted clusters will meet
> these requirements as long as you use Kubernetes version 1.18+.

### HostPath mounts

The host paths required for CVM functionality depend on whether **Caching** is
enabled and on whether **Auto loading of the `shiftfs` kernel module`** is
enabled. These settings can be found under **Manage > Admin > Infrastructure**.

The below table documents the host paths that are mounted:

<!-- markdownlint-disable -->

| Caching | Auto Load `shiftfs` | `/usr/src` | `/lib/modules` | `/var/run` | `/var/lib` |
| ------- | ------------------- | ---------- | -------------- | ---------- | ---------- |
| Off     | N/A                 | Read-only  | Read-only      |            |            |
| On      | Off                 | Read-only  | Read-only      | Read-only  | Read-write |
| On      | On                  | Read-write | Read-write     | Read-only  | Read-write |

<!-- markdownlint-restore -->

## Security

The container-based virtual machine deployment option leverages the Sysbox
container runtime to offer a VM-like user experience while retaining the
footprint of a typical container.

Coder first launches a supervising container with additional privileges. This
container is standard and included with the Coder release package. During the
workspace build process, the supervising container launches an inner container
using the Sysbox container runtime. This inner container is the user’s
[workspace](../../../workspaces/index.md).

The user cannot gain access to the supervising container at any point. The
isolation between the user's workspace container and its outer, supervising
container is what provides
[strong isolation](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/security.md).

## Known issues

- NVIDIA GPUs can be added to CVMs on bare metal clusters only. This feature is
  not supported on Google Kubernetes Engine or other cloud providers at this
  time.

  Support for NVIDIA [GPUs](../gpu-acceleration.md) is in **beta**. We do not
  support AMD GPUs at this time.

- Coder doesn't support legacy versions of cluster-wide proxy services such as
  Istio, and CVMs do not currently support NFS as a file system.

## Next Steps

- [Set up a Kubernetes cluster](cluster-setup.md) for Coder that's capable of
  hosting CVMs
- Learn [how to work with images](images.md) for use with CVMs
- Learn [how to enable CVMs for users](management.md)
