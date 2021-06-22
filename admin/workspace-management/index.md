---
title: "Workspace management"
description: Learn how to manage workspaces from an admin level.
---

Administrative users can modify a variety of workspace-related behaviors.

- From the Coder UI's **Manage** > **Admin** > **Infrastructure** tab, you can
  enable and configure the following features:

  - [Access URL](../access-url.md)
  - [GPU vendor](gpu-acceleration.md)
  - [Workspace container runtime](cvms.md)
  - [Default registries](../registries/default-registry.md)
  - [Extensions](extensions.md)
  - [Dev URL access permissions](../devurls.md#setting-dev-url-access-permissions)
  - [Browser security](../security.md)
  - [Memory overprovisioning](memory-overprovisioning.md)

- You can modify the [Workspace shutdown behavior](shutdown.md) on a
  per-organization basis to optimize resource usage.

- You can [install multiple IDEs](installing-jetbrains.md) onto your image so
  that users have alternatives to the default option (VS Code).

- You can [disable SSH access](ssh-access.md) for users by editing the Helm
  values file (Coder enables SSH access to workspaces by default).

<children></children>
