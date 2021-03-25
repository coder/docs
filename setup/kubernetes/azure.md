---
title: Azure Kubernetes Service
description: Learn how to set up an AKS cluster for your Coder deployment.
---

This deployment guide shows you how to set up an Azure Kubernetes Service (AKS)
cluster on which Coder can deploy.

## Prerequisites

You must have an Azure account and paid subscription.

Please make sure that you have the [Azure
CLI](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
installed on your machine and that you've logged in (run `az login` and follow
the prompts).

## Step 1: Create the Resource Group

To make subsequent steps easier, start by creating environment variables for the
[Resource
Group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group)
and
[Location](https://azure.microsoft.com/en-us/global-infrastructure/geographies/)
that will host your cluster:

```console
RESOURCE_GROUP="<MY_RESOURCE_GROUP_NAME>" LOCATION="<MY_AZURE_LOCATION>"
```

Create a resource group:

```console
az group create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION"
```

If this is successful, Azure returns information about your resource group. Pay
attention to the `id` field:

```console
"id": "/subscriptions/3afe...d2d/resourceGroups/coderdocs"
```

You will need the hash provided (i.e., `3afe...d2d`) when creating your cluster.

## Step 2: Create the Azure Kubernetes Service Cluster

Set two additional environment variables for your cluster name and subscription
ID:

```console
CLUSTER_NAME="<MY_CLUSTER_NAME>" SUBSCRIPTION="<MY_SUBSCRIPTION_SHA>"
```

Create the Azure Kubernetes Service Cluster:

```console
# You may have to run `az extension add --name aks-preview`
#
# You may also need to create a service principal manually using
# `az ad sp create-for-rbac --skip-assignment`, then setting the
# --service-principal and --client-secret flags

az aks create \
  --name "$CLUSTER_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --subscription "$SUBSCRIPTION" \
  --generate-ssh-keys \
  --enable-addons http_application_routing \
  --enable-cluster-autoscaler \
  --location "$LOCATION" \
  --max-count 10 \
  --min-count 2 \
  --node-vm-size Standard_B8ms \
  --network-plugin "kubenet" \
  --network-policy "calico"
```

> [AKS offers built-in
support](https://docs.microsoft.com/en-us/azure/aks/use-network-policies#create-an-aks-cluster-and-enable-network-policy)
for the
[Calico](https://docs.projectcalico.org/getting-started/kubernetes/managed-public-cloud/gke)
network policy engine, and you can opt-in by including the `--network-policy
"calico"` flag.
>
> However, you can only choose Calico as your network policy option when you
create the cluster; you cannot enable Calico on an existing cluster.

This process might take some time (~5-20 minutes), but if you're successful,
Azure returns a JSON object with your cluster information.

## Step 3: Configure kubectl to Point to the Cluster

After deploying your AKS cluster, configure kubectl to point to your cluster:

```console
az aks get-credentials --name "$CLUSTER_NAME" --resource-group $RESOURCE_GROUP"
```

You should get a message similar to the following if this is successful:

```console
Merged "<YOUR_CLUSTER_NAME>" as current context in /Users/<YOUR_USER>/.kube/config
```

## Access Control

You can configure AKS to use both Azure Active Directory (AD) and Kubernetes
Role-Based Access Control (RBAC) to limit access to cluster resources based on
the user's identity or group membership. You can create groups and users in AD,
then define roles to assign to users with role bindings via RBAC.

For more information, see:

- [Azure AD with Kubernetes RBAC](https://docs.microsoft.com/en-us/azure/aks/azure-ad-rbac)
- [Kubernetes RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## Next Steps

At this point, you're ready to proceed to [Installation](../installation.md).
