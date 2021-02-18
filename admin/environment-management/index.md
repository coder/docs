---
title: "Environment Management"
description: Learn how to manage Environments from an admin level.
---

Administrative users can modify a variety of environment-related behaviors.

- From the Coder UI's **Manage** > **Admin** > **Infrastructure** tab, you can
  enable and configure the following features:

  - [GPU Acceleration](gpu-acceleration.md)
  - [Environment Container Runtime](cvms.md)
  - [Default Registries](../registries/default-registry.md)
  - [Extensions](../extensions.md)
  - [Memory Overprovisioning](../memory-overprovisioning.md)

- You can also modify the [Environment Shutdown Behavior](shutdown.md) on a
  per-organization basis to optimize resource usage.

- You can [disable SSH access](ssh-access.md) for your end-users by editing the
  YAML file in helm (by default, Coder enables SSH access to environments).

<children></children>
