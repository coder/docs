---
title: Management
description: Learn how to enable CVMs.
---

Before users can create a [CVM-enabled workspace](../../../workspaces/cvms.md),
a site manager must enable CVMs. To do so:

1. Go to **Manage > Admin > Infrastructure**.
1. Toggle the **Enable Container-Based Virtual Machines** option to **Enable**.

## Customization

Once you've enabled CVMs, you can customize the behavior of your deployment and
workspaces.

![CVM Settings](../../../assets/admin/cvm-settings.png)

These settings will apply to workspaces **after** they have been rebuilt.

## Default workspaces to CVMs

Once you've enabled CVMs, you can set whether all new workspaces should have
CVMs enabled or not.

If you would like all newly created workspaces to be CVMs, toggle **Default to
container-based virtual machines** to **On**.

> While this toggle changes the default workspace creation setting, users can
> still modify this setting. For example, if you enable CVMS and set them as the
> default, a user can still create non-CVM workspaces (and vice versa).

## Caching

> Cached CVMs are currently an **alpha** feature.

To improve the startup time for CVM-based workspaces, you can enable caching.

Cached CVMs require the `shiftfs` kernel to be present on the node. Some
distributions (such as Ubuntu) include `shiftfs`. If you're unsure if `shiftfs`
is present on your nodes, you can check by running `modinfo shiftfs`. If no
output is returned, you do not have `shiftfs` installed.

If you don't want to install `shiftfs` yourself, you can have Coder install the
module automatically for you. **It is important that you do not have secure boot
enabled and that you have the kernel headers installed if you want Coder to
install `shiftfs` on your behalf.**

> GPUs are not supported with cached CVMs at this time.

## Self-contained workspace builds

> Self-contained workspace builds are currently an **alpha** feature.

By default, Coder initializes workspaces by running commands inside the
container. Workspaces, however, control the initialization sequence instead when
you enable [self-contained workspace builds]. This enables cluster operations
that restrict command execution inside containers using the Kubernetes API, such
as the `kubectl exec` command.

[self-contained workspace builds]: ../self-contained-builds.md

## Workspace process logging

> Workspace process logging is currently an **alpha** feature.

[Workspace process logging] enables auditing of commands executed inside the
workspace container.

[workspace process logging]: ../process-logging.md

## TUN device

> TUN devices currently an **alpha** feature.

Coder allows the creation of custom network interfaces using the Linux TUN
device. When using the **Enable TUN device** setting, Coder workspaces will have
a `/dev/net/tun` device mounted into the workspace at build time. VPN usage
often requires a TUN device.

Users may need root (or `sudo`) access within their workspace to use the TUN
device and start a VPN client.

> At this time, Coder does not support TUN devices for non-Kubernetes workspace
> types, such as EC2 or Docker.
>
> If you're working with EC2 workspaces, we recommend enabling privileged mode
> in the workspace provider settings, which will allow users to create their own
> TUN device.

We've tested this feature using the [Tailscale](https://tailscale.com/) VPN
within Coder. Remember that you may have to change your VPN settings to keep any
persistent files (such as configuration/identity) files in your home volume, as
any data outside the home volume is cleared when the workspace is rebuilt.

## FUSE device

> FUSE devices are currently an **alpha** feature.

Coder allows the creation of custom filesystems using the Linux FUSE userspace
filesystem device. By enabling the **Enable FUSE device** setting, Coder
workspaces will have a `/dev/fuse` device mounted into the workspace at build
time. These devices are often used to mount specialized filesystems, such as
Google Cloud Storage buckets, to your workspace.

Users may need root (or `sudo`) access within their workspace to use the FUSE
device and start a FUSE filesystem.

> At this time, Coder does not support FUSE devices for non-Kubernetes workspace
> types, such as EC2 or Docker.
>
> If you're working with EC2 workspaces, we recommend enabling privileged mode
> in the workspace provider settings, which will allow users to create their own
> FUSE device.

For example, you can mount a directory from a remote SSH server using `sshfs`:

```console
mkdir /tmp/mnt
sshfs user@host:/ /tmp/mnt
```

Then, in a second terminal, run `ls /tmp/mnt` to list the files from the remote
host. You should also be able to see a `fuse.sshfs` entry in the output from the
`mount` command.
