---
title: Workspace providers
description: Learn how workspace providers can improve the developer experience.
---

Workspace providers are logical groups of resources to which developers can
deploy workspaces. They enable a single Coder deployment to provision and manage
workspaces across multiple Kubernetes clusters and namespaces, including those
located in other geographies, regions, or clouds.

Distributed teams can use this feature to allow users to manage workspaces in
the nearest cluster. When combined with [satellites](../satellites/index.md),
developers will see an improved experience and reduced network latency.

You can also use workspace providers to support data sovereignty requirements or
increase the isolation between workspaces running in the same region or cluster.

## Built-in workspace provider

By default, all Coder deployments will have a `built-in` workspace provider that
specifies the Kubernetes cluster containing the Coder deployment. This allows
users to create workspaces in the same cluster as the Coder deployment with no
additional configuration.

## Remote workspace providers

You can deploy a workspace provider to any existing Kubernetes cluster, enabling
the cluster to become a selectable pool of resources in which developers can
create workspaces.

Remote workspace providers can lower developers' latency by locating their
workspaces closer to them geographically or can be used for workload isolation
purposes. See [Deploying a workspace provider](deployment/index.md) to learn how
to expand your Coder deployment to additional Kubernetes clusters.

### Organization allowlists

Site admins and site managers can manage which organizations have permissions to
provision new workspaces in each workspace provider. When a new organization is
created, it can provision workspaces into the **built-in** workspace provider by
default.
