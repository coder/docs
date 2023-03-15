# Docker in workspaces

[Container-based virtual machines (CVMs)](../../../workspaces/cvms.md) allow
users to run system-level programs, such as Docker and systemd, in their
workspaces.

If you're a site admin or a site manager, you can enable CVMs as a workspace
deployment option.

## Infrastructure requirements

- Coder implements container-based virtual machines (CVMs) using the
  [Sysbox container runtime](https://github.com/nestybox/sysbox), which allows
  unprivileged users to run system-level applications, such as Docker and
  systemd, securely from their workspace containers. Sysbox requires a
  [compatible Linux distribution](https://github.com/nestybox/sysbox/blob/master/docs/distro-compat.md)
  to implement these security features; for additional information, see the
  [Sysbox User Guide: Design Notes](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/design.md).

  [Nestybox](https://www.nestybox.com/) maintains the Sysbox runtime and
  provides an
  [enterprise offering called Sysbox EE](https://www.nestybox.com/sysbox-ee)
  that includes additional security features and capabilities.

- The cluster must allow privileged containers and `hostPath` mounts. See
  [Security](#security) for more information on why this is still secure.

> You can use any cloud provider that supports the above requirements, but we
> have instructions on how to set up supported clusters on
> [AWS](../../../setup/kubernetes/aws.md) and
> [Google](../../../setup/kubernetes/google.md). Azure-hosted clusters will meet
> these requirements as long as you use Kubernetes version 1.18+.

### HostPath mounts

The host paths required for CVM functionality depend on whether you've enabled
**Caching** and **Auto loading of the `shiftfs` kernel module**. You can find
these settings under **Manage > Admin > Infrastructure**.

The following table documents the host paths that are mounted:

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

> Sysbox is not yet supported on systems with SELinux enabled.

## Known issues

- Do not add configuration files like bash scripts to `/tmp` in CVMs since they
  will not be available once the CVM workspace is built. Consider creating
  another directory like `/mycompanyname`

- Coder requires an older version of `containerd.io` because it contains a
  version of `runc` that works with Sysbox correctly. See our
  [enterprise-base Dockerfile](https://github.com/coder/enterprise-images/blob/main/images/base/Dockerfile.ubuntu)
  for an example or install the following in your Dockerfile
  `containerd.io=1.5.11-1`. In a future release, Coder will update to the latest
  Sysbox version that supports the latest `runc`.

- NVIDIA GPUs can be added to CVMs on bare metal clusters only. This feature is
  not supported on Google Kubernetes Engine or other cloud providers at this
  time.

  Support for NVIDIA [GPUs](../gpu-acceleration.md) is in **beta**. We do not
  support AMD GPUs at this time.

## Next Steps

- [Set up a Kubernetes cluster](cluster-setup.md) for Coder that's capable of
  hosting CVMs
- Learn [how to work with images](images.md) for use with CVMs
- Learn [how to enable CVMs for users](management.md)
- Learn
  [how to mount NFS file shares onto Coder workspaces](../../../guides/admin/nfs.md)
