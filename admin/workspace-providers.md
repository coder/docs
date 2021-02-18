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

**To enable this beta feature in the UI:** click on your avatar. In the menu
that appears, click **Feature Preview**. Select **Resource Pools UI** and click
**Enable**. Once enabled, this allows end-users to choose the workspace provider
and namespace where they want their environment deployed.

## Admin UI

Site managers and admins will also see the workspace providers configuruation
screen avaiable via **Manage** > **Admin** > **Workspace Providers**.

![Workspace Providers Admin](../assets/workspace-providers-admin.png)

The Admin panel will provide high-level information on all of your workspace
providers, as well as whether the provider is active on not. The default tag
indicates the provider that will be automatically selected whenever a user
launches the Create an Environment modal.

You can expand individual listings to view in-depth information:

![Detailed Workspace Providers Info](../assets/workspace-providers-detail.png)

Workspace Providers are available on a per-organization basis. To make
individual workspace providers available to organizations:

1. Expand the workspace provider's listing
2. Click **Edit**
3. Select the organizations whose users should be allowed to use the workspace
   provider
4. Click **Update**.

![Organization Whitelist for Workspace
Providers](../assets/workspace-providers-org-whitelist.png)
