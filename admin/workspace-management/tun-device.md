---
title: TUN device
description: Learn how to enable TUN devices for VPN usage within Coder.
state: alpha
---

By default Coder workspaces don't contain a TUN device for security reasons,
which means running a VPN in a Coder workspace is difficult. Coder offers an
admin configuration setting that will automatically create a TUN device within
all Kubernetes CVM workspaces.

> At this time, Coder does not support other workspace types such as EC2 or
> Docker. For EC2 workspaces, we recommend enabling privileged mode in the
> workspace provider settings instead, which will allow users to create their
> own TUN device.

## Enable TUN devices

To enable TUN devices:

1. Log into Coder.
1. Go to Manage > Admin.
1. On the Infrastructure page, scroll down to **Workspace container runtime**.
1. Under **Enable TUN device**, flip the toggle to **On**.
1. Click **Save workspaces**.

![Enabling TUN devices](../../assets/admin/tun.png)

The new setting will apply to workspaces after they have been rebuilt.

Users running workspaces with TUN devices should be able to run VPN clients
within their workspace as long as they have root (or `sudo`) access within their
workspace.

We've tested using the [Tailscale](https://tailscale.com/) VPN inside of Coder.
