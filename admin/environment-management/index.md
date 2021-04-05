---
title: "Environment management"
description: Learn how to manage environments from an admin level.
---

Administrative users can modify a variety of environment-related behaviors.

- From the Coder UI's **Manage** > **Admin** > **Infrastructure** tab, you can
  enable and configure the following features:

  - [GPU acceleration](gpu-acceleration.md)
  - [Environment container runtime](cvms.md)
  - [Default registries](../registries/default-registry.md)
  - [Extensions](extensions.md)
  - [Memory overprovisioning](memory-overprovisioning.md)

- You can also modify the [Environment shutdown behavior](shutdown.md) on a
  per-organization basis to optimize resource usage.

- You can [disable SSH access](ssh-access.md) for users by editing the Helm
  values file (Coder enables SSH access to environments by default).

<children></children>
