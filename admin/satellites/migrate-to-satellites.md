---
title: Migrate to satellite deployments
description:
  Learn the steps for upgrading to satellites for workspace providers deployed
  before the 1.21 release.
---

Satellites work in tandum with the new NetworkingV2 to create low latency
experiences for geo-distributed teams in the 1.21 release. Previously, remote
workspace providers we based on an envproxy deployment of the
`coder/workspace-provider` helm chart. This document will outline the steps to
migrate from an envproxy-based workspace provider deployment to the new
Networking V2 architecture.

## Dependencies

Install the following dependencies if you haven't already:

- [Coder CLI](../../cli/installation.md)
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Overview

Each region that currently has an envproxy-based workspace provider deployment
(deployed before 1.21) will be replaced with a satellite deployment to fulfill
the same role of proxying to the workspaces located in that region for a low
latency experience. There are some key differences:

- Satellites are only compatible with workspace providers with NetworkingV2
  enabled.
- Developers will access the satellite access URL over the primary deployments
  access URL.

In general the migration steps will be:

1. Deploy satellite deployments in each additional region
1. Enable NetworkingV2 in each workspace provider
1. Use new satellite access URLs

Additionally, there are the following cleanup steps:

1. Annotate Kubernetes resources
1. Uninstall envproxy-based helm chart

Although no down time is expected, users may experience negative impacts latency
during the migration until all steps are completed for the region.

## Deploy satellites

The first step will be to deploy new satellite deployments in each region you
wish to expand into. Follow the steps outlined in
[satellite management](./management.md) for creating a Satellite deployment. It
is recommended to deploy the satellite into a different namespace from the
existing workspace provider. The access URL for these deployments will be used
by developers to connect to the Satellites instead of the primary Coder
deployment. A common pattern for hostnames may be `coder.example.com` for the
primary Coder deployment and `coder-sydney.example.com` for the
`australia-southeast1` region.

## Enable NetworkingV2

Navigate to **Manage** > **Providers** and select the workspace provider. Enable
the NetworkingV2 toggle and save.

Rebuild a workspace and ensure connectivity to the workspace before moving onto
the next steps. Note that latency to the workspace may be negatively impacted in
this step until users are connecting to the new replica deployments.

## Using the satellite access URLs

Developers will always have the lowest latency possible by connecting to the
Coder deployment closed to them geographically. Therefore, the users in
Australia should always connect to the `coder-sydney.example.com` deployment.

## Annotate Kubernetes resources

The old envproxy-based workspace provider deployment is no longer in use.
However the Kubernetes ServiceAccount, Role, and RoleBindings created by the
helm chart are still required. To safely remove the unused helm chart, we will
add an annotation to the resources we'd like to keep first.

Ensure the following commands are ran with the namespace flag of the
`coder/workspace-provider` helm chart. You can check by running

```bash
helm list -n <NAMESPACE>
```

Add the following annotations to the resources:

```bash
kubectl annotate serviceaccount coder "helm.sh/resource-policy=keep" -n <NAMESPACE>
kubectl annotate role coder "helm.sh/resource-policy=keep" -n <NAMESPACE>
kubectl annotate rolebinding coder "helm.sh/resource-policy=keep" -n <NAMESPACE>
```

Now the authentication resources will be protected when the helm uninstall is
ran.

## Uninstall workspace provider helm chart

Uninstall the `coder/workspace-provider` helm chart with the following command:

```bash
helm uninstall coder-workspace-provider -n <NAMESPACE>
```

Notice the `coder` ServiceAccount, Role, and RoleBinding will still persist as
these are required for Coder to authenticate to the Kubernetes Cluster and
provision workspaces.
