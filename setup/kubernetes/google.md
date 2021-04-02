---
title: Google Kubernetes Engine
description: Learn how to set up a GKE cluster for your Coder deployment.
---

This guide shows you how to set up a Google Kubernetes Engine (GKE) cluster to
which Coder can deploy.

## Prerequisites

Before proceeding, make sure that the
[gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts) is installed on your
machine and configured to interact with your Google Cloud Platform account.

## Set Up the GKE Cluster

The following commands will spin up a Kubernetes cluster using the `gcloud`
command.

The first option creates a cluster that meets Coder's minimum requirements. The
second option creates a cluster capable of supporting use of the
[CVMs](../../admin/environment-management/cvms.md) deployment option.

Regardless of which option you choose, be sure to replace the following
parameters to reflect the needs of your environment: `PROJECT_ID`,
`NEW_CLUSTER_NAME`, `ZONE`.

### Option 1: Cluster with full support of Coder features

```console
gcloud beta container --project "$PROJECT_ID" \
clusters create "$NEW_CLUSTER_NAME" \
   --zone "$ZONE" \
   --no-enable-basic-auth \
   --cluster-version "latest" \
   --machine-type "n1-highmem-4" \
   --image-type "COS" \
   --disk-type "pd-standard" \
   --disk-size "50" \
   --metadata disable-legacy-endpoints=true \
   --scopes "https://www.googleapis.com/auth/cloud-platform" \
   --num-nodes "2" \
   --enable-stackdriver-kubernetes \
   --enable-ip-alias \
   --network "projects/$PROJECT_ID/global/networks/default" \
   --subnetwork \
   "projects/$PROJECT_ID/regions/$ZONE/subnetworks/default" \
   --default-max-pods-per-node "110" \
   --addons HorizontalPodAutoscaling,HttpLoadBalancing \
   --enable-autoupgrade \
   --enable-autorepair \
   --enable-network-policy \
   --enable-autoscaling \
   --min-nodes "1" \
   --max-nodes "8"
```

> The example above includes the use of the `enable-network-policy` flag, which
> will result in the
> [creation of a Calico cluster](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/calico-network-policy/).

### Option 2: Cluster meeting minimum requirements for Coder

```console
gcloud beta container --project "$PROJECT_ID" \
    clusters create "$NEW_CLUSTER_NAME" \
    --zone "$ZONE" \
    --no-enable-basic-auth \
    --node-version "latest" \
    --cluster-version "latest" \
    --machine-type "n1-highmem-4" \
    --image-type "UBUNTU" \
    --disk-type "pd-standard" \
    --disk-size "50" \
    --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/cloud-platform" \
    --num-nodes "2" \
    --enable-stackdriver-kubernetes \
    --enable-ip-alias \
    --network "projects/$PROJECT_ID/global/networks/default" \
    --subnetwork \
    "projects/$PROJECT_ID/regions/$ZONE/subnetworks/default" \
    --default-max-pods-per-node "110" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing \
    --enable-autoupgrade \
    --enable-autorepair \
    --enable-network-policy \
    --enable-autoscaling \
    --min-nodes "1" \
    --max-nodes "8"
```

This process may take ~15-30 minutes to complete.

## Access Control

GKE allows you to integrate Identity Access and Management (IAM) with
Kubernetes' native Role-Based Access Control (RBAC) mechanism to authorize user
actions in the cluster. IAM configuration is primarily applied at the project
level and to all clusters within that project. Kubernetes RBAC configuration
applies to individual clusters, allowing you to implement fine-grained
authorization right down to the namespace level.

For more information, see:

- [GKE Interaction with IAM](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#iam-interaction)
- [Kubernetes RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## Next Steps

At this point, you're ready to proceed to [Installation](../installation.md).
