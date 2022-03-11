---
title: Management
description: Learn how to enable CVMs.
---

Before users can create a [CVM-enabled workspace](../../../workspaces/cvms.md),
a site manager must enable CVMs. To do so:

1. Go to **Manage > Admin > Infrastructure**.
1. Toggle the **Enable Container-Based Virtual Machines** option to **Enable**.

This section describes the customization features that Coder offers for CVMs as
well:

![CVM Settings](../../../assets/admin/cvm-settings.png)

## Caching

> Cached CVMs are currently an **alpha** feature.

To improve the startup time for CVM-based workspaces, you can enable caching.

Cached CVMs require the `shiftfs` kernel to be present on the node. Some
distributions (such as Ubuntu) include `shiftfs`. If you're unsure if `shiftfs`
is present on your nodes, you can check by running `modinfo shiftfs`. If no
output is returned, then you do not have `shiftfs` installed.

If you don't want to install `shiftfs` yourself, you can have Coder install the
module automatically for you. **It is important that you do not have secure boot
enabled and that you have the kernel headers installed if you want Coder to
install `shiftfs` on your behalf.**

> GPUs are not supported with cached CVMs at this time.

## Self-contained workspace builds

> Self-contained workspace builds are currently an **alpha** feature.

By default, Coder initializes workspaces by running commands inside the
container. When you enable [self-contained workspace builds], workspaces control
the initialization sequence instead. This enables operation on clusters that
restrict command execution inside containers using the Kubernetes API, such as
with the `kubectl exec` command.

[self-contained workspace builds]: ../self-contained-builds.md

## Workspace process logging

> Workspace process logging is currently an **alpha** feature.

[Workspace process logging] enables auditing of commands executed inside the
workspace container.

[workspace process logging]: ../process-logging.md

## TUN device

> TUN devices currently an **alpha** feature.

Coder allows the creation of custom network interfaces using the kernel TUN
device. When using the **Enable TUN device** setting, Coder workspaces will have
a `/dev/net/tun` device mounted into the workspace at build time. These devices
are often required for VPN clients, such as OpenVPN and Tailscale.

> At this time, Coder does not support TUN devices for other workspace types
> (such as EC2 or Docker).
>
> If you're working with EC2 workspaces, we recommend enabling privileged mode
> in the workspace provider settings, which will allow users to create their own
> TUN device.

## FUSE device

> FUSE devices currently an **alpha** feature.

Coder allows the creation of custom filesystems using the kernel TUN device.
When using the **Enable FUSE device** setting, Coder workspaces will have a
`/dev/fuse` device mounted into the workspace at build time. These devices are
frequently used to mount specialized filesystems, such as Google Cloud Storage
buckets, as a filesystem volume.

> At this time, Coder does not support FUSE devices for other workspace types
> (such as EC2 or Docker).
>
> If you're working with EC2 workspaces, we recommend enabling privileged mode
> in the workspace provider settings, which will allow users to create their own
> FUSE device.
