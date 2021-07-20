---
title: Workspace providers
description: Learn how workspace providers can improve developer experience.
state: beta
---

Workspace providers are logical groups of resources to which developers can
deploy workspaces. They enable a single Coder deployment to provision and manage
workspaces across multiple Kubernetes clusters and namespaces, including those
located in other geographies, regions, or clouds.

Distributed teams can use this feature to allow users to manage workspaces in
the nearest cluster. This reduces network latency and improves developers'
experience.

You can also use workspace providers to support data sovereignty requirements or
increase the isolation between workspaces running in the same region or cluster.

## Built-in workspace provider

By default, all Coder deployments will have a `built-in` workspace provider that
specifies the Kubernetes cluster containing the Coder deployment. This allows
users to create workspaces in the same cluster as the Coder deployment with no
additional configuration.

You cannot delete the `built-in` workspace provider.

## Remote workspace providers

You can deploy a workspace provider to any existing Kubernetes cluster, enabling
the cluster to become a selectable pool of resources in which developers can
create workspaces.

Remote workspace providers can lower developers' latency by locating their
workspaces closer to them geographically or can be used for workload isolation
purposes. See [Deploying a workspace provider](deployment.md) to learn how to
expand your Coder deployment to additional Kubernetes clusters.

## Admin UI

Site admins and site managers can view the workspace providers configuration
page available via **Manage** > **Admin** > **Workspace Providers**.

![Workspace providers admin](../../assets/admin/workspace-providers-admin.png)

The Admin panel shows an overview of all configured workspace providers and
indicates their statuses and details. The **default** tag indicates the provider
that will be selected by default when a user creates a workspace using the
**Create a Workspace** dialog.

You can expand individual listings to view in-depth information:

![Detailed workspace providers
info](../../assets/admin/workspace-providers-detail.png)

### Status

A workspace provider can have one of the following statuses:

- **Ready**: The workspace provider is online and available, and you can
  provision new workspaces to it.
- **Error**: The workspace provider encountered an issue on startup or cannot be
  reached by the Coder deployment. The workspace provider's details will include
  an error message.

### Organization allowlists

Site admins and site managers can manage which organizations have permissions to
provision new workspaces in each workspace provider. When a new organization is
created, it can provision workspaces into the `built-in` workspace provider by
default.

Organizations must not contain any workspaces in the workspace provider before
you remove them from a workspace provider's allowlist.
