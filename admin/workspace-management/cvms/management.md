---
title: Management
description: Learn how to enable CVMs.
---

Before users can create a [CVM-enabled workspace](../../../workspaces/cvms.md),
a site manager must enable CVMs. To do so:

1. Go to **Manage > Admin > Infrastructure**.
1. Toggle the **Enable Container-Based Virtual Machines** option to **Enable**.

### Enabling cached CVMs

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

![Cached CVMs](../../../assets/admin/cached-cvms.png)
