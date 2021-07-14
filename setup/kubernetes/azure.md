---
title: Azure Kubernetes Service
description: Learn how to set up an AKS cluster for your Coder deployment.
---

This deployment guide shows you how to set up an Azure Kubernetes Service (AKS)
cluster on which Coder can deploy.

## Prerequisites

You must have an Azure account and paid subscription.

Please make sure that you have the
[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
installed on your machine and that you've logged in (run `az login` and follow
the prompts).

## Node Considerations

The node type and size that you select impact how you use Coder. When choosing,
be sure to account for the number of developers you expect to use Coder, as well
as the resources they need to run their workspaces. See our guide on on [compute
resources](../../guides/admin/resources.md) for additional information.

If you expect to provision GPUs to your Coder workspaces, you **must** use an
Azure Virtual Machine with support for GPUs. See the [Azure
documentation](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-gpu)
for more information.

> GPUs are not supported in workspaces deployed as [container-based virtual
> machines (CVMs)](../../workspaces/cvms.md) unless you're running Coder in a
> bare-metal Kubernetes environment.

## Step 1: Create the resource group

To make subsequent steps easier, start by creating environment variables for the
[resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group)
and
[location](https://azure.microsoft.com/en-us/global-infrastructure/geographies/)
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

## Step 2: Create the Azure Kubernetes Service cluster

Set two additional environment variables for your cluster name and subscription
ID:

```console
CLUSTER_NAME="<MY_CLUSTER_NAME>" SUBSCRIPTION="<MY_SUBSCRIPTION_SHA>"
```

At this point, you're ready to create your cluster. Please note that:

- You may have to run `az extension add --name aks-preview`
- You may need to create a service principal manually using
  `az ad sp create-for-rbac --skip-assignment`, then setting the
  `--service-principal` and `--client-secret` flags
- The sample script creates a `Standard_B8ms` instance; depending on your needs,
  you can choose a
  [larger size](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable)
  instead. See [requirements](../requirements.md) for help estimating your
  cluster size.

To create the Azure Kubernetes Service Cluster:

```console
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

> [AKS offers built-in support](https://docs.microsoft.com/en-us/azure/aks/use-network-policies#create-an-aks-cluster-and-enable-network-policy)
> for the
> [Calico](https://docs.projectcalico.org/getting-started/kubernetes/managed-public-cloud/gke)
> network policy engine, and you can opt-in by including the
> `--network-policy "calico"` flag.
>
> However, you can only choose Calico as your network policy option when you
> create the cluster; you cannot enable Calico on an existing cluster.

This process might take some time (~5-20 minutes), but if you're successful,
Azure returns a JSON object with your cluster information.

## Step 3: Configure kubectl to point to the cluster

After deploying your AKS cluster, configure kubectl to point to your cluster:

```console
az aks get-credentials --name "$CLUSTER_NAME" --resource-group "$RESOURCE_GROUP"
```

You should get a message similar to the following if this is successful:

```console
Merged "<YOUR_CLUSTER_NAME>" as current context in /Users/<YOUR_USER>/.kube/config
```

## Access control

You can configure AKS to use both Azure Active Directory (AD) and Kubernetes
Role-Based Access Control (RBAC) to limit access to cluster resources based on
the user's identity or group membership. You can create groups and users in AD,
then define roles to assign to users with role bindings via RBAC.

For more information, see:

- [Azure AD with Kubernetes RBAC](https://docs.microsoft.com/en-us/azure/aks/azure-ad-rbac)
- [Kubernetes RBAC authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## Next steps

To access Coder through a secure domain, review our guides on configuring and
using [SSL certificates](../../guides/ssl-certificates/index.md).

Once complete, see our page on [installation](../installation.md).
