---
title: "Getting started"
description: "Learn how to develop in a workspace."
---

This article walks you through creating a new workspace using a pre-defined
image.

![Relationship between images and workspaces](../assets/workspaces/lifecycles.png)

## 1. Import an image

Ensure you've [imported an image](../images/importing.md) for your
[workspace](index.md) to use.

## 2. Create a workspace

If this is your first time using Coder, you'll see a **Create Workspace** button
in the middle of your screen; otherwise, you'll see a list of your existing
workspaces. Click the **New Environment** button and choose **Custom
Workspace**.

> To learn more about creating an environment from templates, see
> [Workspace templates](workspace-templates/index.md).

![Create a workspace](../assets/workspaces/create-workspace.png)

1. Enter a friendly name for your workspace, and choose an
   [image](../images/index.md) to use.

1. Set the [parameters](workspace-params.md) for your workspace.

1. Click **Create** to proceed.

Coder redirects you to an overview page for your workspace during the build
process. Learn more about the workspace
[creation parameters](./workspace-params.md).

![Workspace overview](../assets/workspaces/workspace-overview.png)

Your workspace persists in the home directory, updates itself to new versions of
the image on which it is built, and runs custom configuration on startup. Learn
about the [workspace lifecycle](lifecycle.md).

### Workspace status

The workspace overview page displays information regarding the status and
performance of your workspace.

![Workspace overview](../assets/workspaces/status-chip.png)

The following workspace statuses are available:

- **Running**: Your workspace is running
- **Off**: Your workspace has been shut off either manually or due to inactivity
- **Error**: An unknown error has occurred
- **Building**: Your workspace is building
- **Turning off**: Your workspace is turning off
- **Unknown**: Your workspace is in an unknown state
- **Initializing**: The container is initializing
- **Decommissioned**: Your workspace is being deleted, and compute resources are
  being released.

### Advanced

Coder provides advanced settings that allow you to customize your workspace.

If your Coder deployment has
[container-based virtual machines enabled](../admin/workspace-management/cvms.md),
Coder creates your workspace as a [CVM](cvms.md) by default (you can opt-out of
this setting by unchecking the **Run as Container-based Virtual Machine** box).

You can also specify the resources Coder should allocate.

> By default, Coder allocates resources (CPU Cores, Memory, and Disk Space)
> based on the parent image.
>
> Coder displays a warning if you choose your resource settings and they're less
> than the image-recommended default, but you can still create the workspace.

## 3. Start Coding

Once you've created a workspace, it's time to hop in. Read more about how to
[connect your favorite editor or IDE](./editors.md) with your new workspace!

![Start coding](../assets/guides/deployments/applications.png)

> [Integrate with Git](./personalization#git-integration) to have your SSH key
> injected automatically into Workspaces.
