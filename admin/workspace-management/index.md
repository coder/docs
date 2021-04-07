---
title: "Workspace management"
description: Learn how to manage workspaces from an admin level.
---

Administrative users can modify a variety of workspace-related behaviors.

- From the Coder UI's **Manage** > **Admin** > **Infrastructure** tab, you can
  enable and configure the following features:

  - [GPU acceleration](gpu-acceleration.md)
  - [Workspace container runtime](cvms.md)
  - [Default registries](../registries/default-registry.md)
  - [Extensions](extensions.md)
  - [Memory overprovisioning](memory-overprovisioning.md)

- You can also modify the [Workspace shutdown behavior](shutdown.md) on a
  per-organization basis to optimize resource usage.

- You can [disable SSH access](ssh-access.md) for users by editing the Helm
  values file (Coder enables SSH access to workspaces by default).

<children></children>
