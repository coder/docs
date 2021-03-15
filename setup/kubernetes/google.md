---
title: Google Kubernetes Engine
description: Learn how to set up a GKE cluster for your Coder deployment.
---

This guide shows you how to set up a Google Kubernetes Engine (GKE) cluster to
which Coder can deploy.

## Prerequisites

Before proceeding, make sure that the [gcloud
CLI](https://cloud.google.com/sdk/docs/quickstarts) is installed on your machine
and configured to interact with your Google Cloud Platform account.

## Set Up the GKE Cluster

The following will spin up a Kubernetes cluster using the `gcloud` command (be
sure to replace the parameters (specifically `PROJECT_ID`,
`NEW_CLUSTER_NAME`, and `ZONE`) as needed to reflect the needs of your environment).

```bash
gcloud beta container --project "$PROJECT_ID" \
clusters create "$NEW_CLUSTER_NAME" \
   --zone "$ZONE" \
   --no-enable-basic-auth \
   --cluster-version "latest" \
   --machine-type "n1-standard-4" \
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

To create clusters capable of supporting use of the
[CVMs](../../admin/environment-management/cvms.md) deployment option:

```bash
gcloud beta container --project "$PROJECT_ID" \
    clusters create "$NEW_CLUSTER_NAME" \
    --zone "$ZONE" \
    --no-enable-basic-auth \
    --node-version "latest" \
    --cluster-version "latest" \
    --machine-type "n1-standard-2" \
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
