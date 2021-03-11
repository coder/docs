---
title: Workspace Providers
description: Learn how workspace providers can minimize latency for users.
state: beta
---

Workspace providers are logical groups of resources to which developers can 
deploy workspaces. Workspace providers enable a single Coder deployment to
provision and manage workspaces across multiple Kubernetes clusters and
namespaces, including those that are located in other geographies, regions, 
or clouds.

Distributed teams can use this feature to allow users to manage workspaces in
the cluster that's nearest, reducing network latency and improving developers'
experience. Additionally, you can use workspace providers to support data
sovereignty requirements or increase the isolation between workspaces running in
the same region or cluster.

### Built-In Workspace Provider

By default, all Coder deployments will have a `built-in` workspace provider that
specifies the Kubernetes cluster that contains the Coder deployment. This allows
users to create workspaces in the same cluster as the Coder deployment with no 
additional configuration.

### Remote Workspace Providers

A workspace provider can be deployed into any existing Kubernetes cluster, and
will enable that cluster to become a selectable pool of resources developers can
create workspaces in. Remote workspace providers can provide lower latency to
developers by locating their workspaces closer to them geographically, or can be
used for workload isolation purposes. See
[Deploying A Workspace Provider](../../guides/deploying-workspace-provider.md)
to learn how you can expand your Coder deployment to additional Kubernetes
clusters.

## Admin UI

Site managers and admins can view the workspace providers configuration page
available via **Manage** > **Admin** > **Workspace Providers**.

![Workspace Providers Admin](../../assets/workspace-providers-admin.png)

The Admin panel shows an overview of all configured workspace providers and
indicates their statuses and details. The **default** tag indicates the provider
initially selected when a user creates an environment using the Create an
Environment dialog.

You can expand individual listings to view in-depth information:

![Detailed Workspace Providers Info](../../assets/workspace-providers-detail.png)

### Statuses

A workspace provider can have one of the following statuses:

- Pending: The workspace provider has been registered, but has not yet been
  successfully deployed into the remote Kubernetes cluster.
- Ready: The workspace provider is online, available, and new workspaces can be
  provisioned into it.
- Error: The workspace provider encountered an issue on startup or cannot be
  reached by the Coder deployment. An error message will be provided in the
  workspace provider's details.

### Organization Allowlists

Site managers & admins can manage which organizations have permissions to
provision new workspaces in each workspace provider. When a new organization is
created it is allowed to provision workspaces into the `built-in` workspace
provider by default. Organizations must not contain any workspaces in the
workspace provider prior to being removed from that workspace provider's
allowlist.

### Workspace Provider Lifecycle

Creation and deletion of workspace providers is done via the Coder CLI. Any
configuration changes to the details of the workspace provider are applied
via Helm when the workspace provider is deployed and updated. For more
information see [Deploying A Workspace Provider](../../guides/deploying-workspace-provider.md).
