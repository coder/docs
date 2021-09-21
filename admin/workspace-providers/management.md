---
title: Workspace provider management
description: Learn how to manage a workspace provider.
---

This article walks you through the process of managing your workspace provider
via the Coder UI.

## Admin UI

Site admins and site managers can view the workspace providers configuration
page available via **Manage** > **Workspace Providers**.

![Workspace providers admin](../../assets/admin/workspace-providers-admin.png)

The Admin panel shows an overview of all configured workspace providers and
indicates their statuses and details.

## Statuses

A workspace provider can have one of the following statuses:

- **Pending**: The workspace provider has been registered but not deployed to
  the remote Kubernetes cluster.
- **Ready**: The workspace provider is online and available, and you can
  provision new workspaces to it.
- **Error**: The workspace provider encountered an issue on startup or cannot be
  reached by the Coder deployment. The workspace provider's details will include
  an error message.

## Edit a workspace provider

To edit a workspace provider, log in to Coder, and go to **Manage** >
**Providers**.

In the **Providers** list, find the workspace provider you want to edit. Click
the vertical ellipsis to its right, and select **Edit**.

At this point, you can:

- Change the **name of the provider**.

- Select the **organizations** that can use this provider; if you do not select
  at least one organization, no one will be able to provision workspaces using
  this provider.

  > Organizations must not contain any workspaces in the workspace provider
  > before you remove them from a workspace provider's allowlist.

- Change the features of the workspace provider. You can:

  - Enable **end-to-end encryption** for this provider
  - Enable **external SSH connections** to the provider's workspaces via the
    Coder CLI
  - Specify a **Kubernetes storage class** to use when Coder provisions
    workspaces (this is useful for improving disk performance)
  - Specify the **Kubernetes service account** that Coder uses to provision
    workspaces

  > If you enable **end-to-end encryption**, end-users using SSH need to rerun
  > `coder config-ssh`.

- Specify the Kubernetes `tolerations` and `nodeSelector` for the workspaces
  deployed with this provider:

  ```json
  {
    "tolerations": [],
    "nodeSelector": {}
  }
  ```

Once you've made your changes, click **Update Provider** to save and continue.

## Delete a workspace provider

1. Log in to Coder, and go to **Manage** > **Providers**.

1. In the **Providers** list, find the workspace provider you want to delete.
   Click the vertical ellipsis to its right. Select **Delete**.

1. Confirm that you want to delete the provider; once deleted, no user will be
   able to provision workspaces using that provider.

> You can only remove a workspace provider if it no longer contains any
> workspaces, so you must remove all workspaces before deleting the workspace
> provider.
