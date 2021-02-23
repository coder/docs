---
title: Workspace Providers
description: Learn how workspace providers can minimize latency for users.
state: beta
---

Workspace Providers are a forthcoming feature that will enable a single Coder
deployment to provision and manage workspaces across multiple Kubernetes
clusters and namespaces, including ones located in other geographies, regions,
or clouds.

Distributed teams can use this feature to allow users to manage workspaces in
the cluster that's nearest, reducing network latency and improving developers'
experience. Additionally, you can use workspace providers to support data
sovereignty requirements or increase the isolation between workspaces running in
the same region or cluster.

## Admin UI

Site managers and admins can view the workspace providers configuration
page available via **Manage** > **Admin** > **Workspace Providers**.

![Workspace Providers Admin](../assets/workspace-providers-admin.png)

The Admin panel shows an overview of all configured workspace providers and
indicates whether they are active. The **default** tag indicates the provider
that is initially selected when a user creates an environment using the Create
an Environment dialog.

You can expand individual listings to view in-depth information:

![Detailed Workspace Providers Info](../assets/workspace-providers-detail.png)
