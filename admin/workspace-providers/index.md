---
title: Workspace Providers
description: Learn how workspace providers can improve developer experience.
state: beta
---

Workspace providers are logical groups of resources to which developers can
deploy environments. They enable a single Coder deployment to provision and manage
environments across multiple Kubernetes clusters and namespaces, including those
located in other geographies, regions, or clouds.

Distributed teams can use this feature to allow users to manage environments in
the nearest cluster. This reduces network latency and improves
developers' experience.

You can also use workspace providers to support data sovereignty requirements or
increase the isolation between environments running in the same region or cluster.

## Built-In Workspace Provider

By default, all Coder deployments will have a `built-in` workspace provider that
specifies the Kubernetes cluster containing the Coder deployment. This allows
users to create environments in the same cluster as the Coder deployment with no
additional configuration.

You cannot delete the `built-in` workspace provider.

## Remote Workspace Providers

You can deploy a workspace provider to any existing Kubernetes cluster, enabling
the cluster to become a selectable pool of resources in which developers can
create environments.

Remote workspace providers can provide lower latency to developers by locating
their environments closer to them geographically or can be used for workload
isolation purposes. See [Deploying A Workspace
Provider](deployment.md) to learn how you can
expand your Coder deployment to additional Kubernetes clusters.

## Admin UI

Site admins and site managers can view the workspace providers configuration page
available via **Manage** > **Admin** > **Workspace Providers**.

![Workspace Providers Admin](../../assets/workspace-providers-admin.png)

The Admin panel shows an overview of all configured workspace providers and
indicates their statuses and details. The **default** tag indicates the provider
that will be selected by default when a user creates an environment using the
Create an Environment dialog.

You can expand individual listings to view in-depth information:

![Detailed Workspace Providers
Info](../../assets/workspace-providers-detail.png)

### Statuses

A workspace provider can have one of the following statuses:

- **Pending**: The workspace provider has been registered but not deployed to
  the remote Kubernetes cluster.
- **Ready**: The workspace provider is online and available, and you can
  provision new environments to it.
- **Error**: The workspace provider encountered an issue on startup or cannot be
  reached by the Coder deployment. The workspace provider's details will include
  an error message.

### Organization Allowlists

Site admins and site managers can manage which organizations have permissions to
provision new environments in each workspace provider. When a new organization is
created, it can provision environments into the `built-in` workspace provider by
default.

Organizations must not contain any environments in the workspace provider before
you remove them from a workspace provider's allowlist.

### Access URL Updates

For deployments with multiple workspace providers, you must ensure the providers
can communicate with the Coder deployment to ensure no downtime for those
environments. If you wish to change the Coder Access URL after you have deployed
addition workspace providers (outside the `built-in` workspace provider) you
should do the following steps:

1. Ensure the new URL resolves to the Coder deployment.
1. Change the Coder Access URL via the
   **Manage** > **Admin** > **Infrastructure** page. The old url should continue
   to resolve to the Coder deployment at this step.
1. [Redeploy each remote workspace provider](./deployment.md#upgrading-the-workspace-provider)
   and use the flag:

  ```bash
    --set cemanager.accessURL=[NEW_ACCESS_URL]`
  ```

1. Confirm the remote workspace providers are deployed successfully with the
   new access URL and environments are still accessible.
1. Now you can remove any DNS records resolving the old access URL.

### Workspace Provider Lifecycle

You can create and delete workspace providers via the Coder CLI.

Helm will apply any configuration changes you make to the workspace provider
details whenever the workspace provider is deployed and updated.

For more information, see [Deploying A Workspace Provider](deployment.md).
