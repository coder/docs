---
title: Migrate to satellite deployments
description:
  Learn how to migrate workspace providers deployed before v1.21 to satellites.
---

Coder v1.21 (and later) feature satellites, which work in tandem with Networking
v2, to provide low latency experiences for geo-distributed teams.

This article outlines the steps required to migrate from an `envproxy`-based
workspace provider deployment (used in Coder v1.20.x and earlier) to one using
the Networking v2 architecture present in Coder 1.21.x and later.

> For in-depth information on Coder's networking changes (which appear in
> v1.21.0), see
> [Rearchitecting Coder’s networking with WebRTC](https://coder.com/blog/rearchitecting-coder-networking-with-webrtc).

## Overview

Each region that currently has an `envproxy`-based workspace provider deployment
must be replaced with a satellite deployment (the satellite deployment is tasked
with the same proxy-related tasks for the workspaces located in that region).

> Satellites are only compatible with workspace providers with Networking v2
> enabled.

### Using satellite access URLs

Developers will always have the lowest latency possible by connecting to the
Coder deployment closed to them geographically. Therefore, they should use the
access URL for the satellite deployment (e.g., those in the
`australia-southeast1` region would use `coder-sydney.example.com`) instead of
the access URL for the primary Coder deployment (e.g., `coder.example.com`)

## Dependencies

Install the following dependencies if you haven't already:

- [Coder CLI](../../cli/installation.md)
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Migration

To migrate, you must:

1. Deploy satellites in each additional region
1. Enable Networking v2 for each workspace provider
1. Annotate the Kubernetes resources
1. Uninstall the `envproxy`-based Helm chart

Though we expect you to see no downtime, end-users may experience negative
impact to latency during the migration process for their region.

### Step 1: Deploy satellites

The first step is to deploy new satellites into each region to which you're
expanding. To do so, follow the steps outlined in
[satellite management](./management.md).

We recommend deploying the satellite into a namespace that's different from the
one you're using for the existing workspace provider. Furthermore, because the
satellite doesn't have any dependencies on the workspaces, you can deploy a
satellite to any cluster and any namespace.

### Step 2: Enable Networking v2

Log into Coder as a site manager, and go to **Manage** > **Providers**. Select
the workspace provider, click the **vertical ellipsis** to its right, and select
**Edit**. Enable the **NetworkingV2 toggle** and click **Update Provider**.

At this point, rebuild a workspace to ensure connectivity between the workspace
provider and the workspace. Note that latency to the workspace may be negatively
impacted until users connect to the new satellite deployments.

Repeat this step for each of your workspace providers.

### Step 3: Annotate the Kubernetes resources

At this point, the old `envproxy`-based workspace provider deployment (and its
Helm chart) is no longer in use. However, Coder still requires the Kubernetes
`ServiceAccount`, `Role`, and `RoleBindings` created by the Helm chart. These
are required for Coder to authenticate to the Kubernetes cluster and provision
workspaces.

To safely remove the unused Helm chart, add an annotation to the resources you
need to keep.

> **WARNING**: If these resources are removed, the existing workspace provider
> becomes non-functional, and you will need to create a new workspace provider
> in its place.

Ensure that you run the following commands with the namespace flag of the
`coder/workspace-provider` helm chart. You can verify this by running:

```console
helm list -n <NAMESPACE>
```

Add the following annotations to the Kubenetes resources:

```console
kubectl annotate serviceaccount coder "helm.sh/resource-policy=keep" -n <NAMESPACE>
kubectl annotate role coder "helm.sh/resource-policy=keep" -n <NAMESPACE>
kubectl annotate rolebinding coder "helm.sh/resource-policy=keep" -n <NAMESPACE>
```

Now, the authentication resources will be protected when you run
`helm uninstall`.

### Step 4: Uninstall the workspace provider Helm chart

Uninstall the `coder/workspace-provider` Helm chart (be sure to update the
following with your namespace):

```console
helm uninstall coder-workspace-provider -n <NAMESPACE>
```
