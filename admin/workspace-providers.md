---
title: Workspace Providers
description: Learn how workspace providers can minimize latency for users.
state: beta
---

Coder allows you to add to your deployment multiple Kubernetes clusters. These
additional clusters are called **providers**. This can be helpful for
distributed teams, since users can choose the provider closest to them to
minimize latency.

## Enabling Workspace Providers

To enable the Workspace Providers UI elements:

1. In the Coder UI, click on your avatar.
2. In the menu that appears, click **Feature Preview**.
3. Select **Resource Pools UI** and click **Enable**.

Once enabled, end users can select the workspace provider and namespace that
will contain their environment.

## Admin UI

Site managers and admins can view the workspace providers configuruation
page available via **Manage** > **Admin** > **Workspace Providers**.

![Workspace Providers Admin](../assets/workspace-providers-admin.png)

The Admin panel shows an overview of all configured workspace providers and
indicates whether they are active. The **default** tag indicates the provider
that is initially selected when a user creates an environment using the Create
an Environment dialog.

You can expand individual listings to view in-depth information:

![Detailed Workspace Providers Info](../assets/workspace-providers-detail.png)

Workspace Providers are available on a per-organization basis. Site managers can
configure the organizations permitted to use a particular Workspace Provider as
follows:

1. Expand the workspace provider's listing
2. Click **Edit**
3. Select the organizations whose users should be allowed to use the workspace
   provider
4. Click **Update**.

![Organization Whitelist for Workspace
Providers](../assets/workspace-providers-org-whitelist.png)
