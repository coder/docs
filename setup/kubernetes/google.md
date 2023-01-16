# Google Kubernetes Engine

This guide shows you how to set up a Google Kubernetes Engine (GKE) cluster to
which Coder can deploy.

## Prerequisites

Before proceeding, make sure that the
[gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts) is installed on your
machine and configured to interact with your Google Cloud Platform account.

Alternatively, you can
[create your cluster using the Google Cloud Console](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-zonal-cluster#creating-a-cluster)
instead of the gcloud CLI. Please refer to the sample CLI commands below for
assistance selecting the correct options for your cluster.

## Node Considerations

The node type and size that you select impact how you use Coder. When choosing,
be sure to account for the number of developers you expect to use Coder, as well
as the resources they need to run their workspaces. See our guide on on
[compute resources](../../guides/admin/resources.md) for additional information.

> In GKE version 1.24 and later, Docker-based [node image types](https://cloud.google.com/kubernetes-engine/docs/concepts/node-images)
> are not supported. The examples below use `ubuntu_containerd` and
> `cos_containerd` to meet this requirement. Docker-based node images will
> prevent GKE cluster creation.

If you expect to provision GPUs to your Coder workspaces, you **must** use a
general-purpose
[N1 machine type](https://cloud.google.com/compute/docs/machine-types#gpus) in
your GKE cluster and add GPUs to the nodes. We recommend doing this in a
separate GPU-specific node pool.

> GPUs are not supported in workspaces deployed as
> [container-based virtual machines (CVMs)](../../workspaces/cvms.md) unless
> you're running Coder in a bare-metal Kubernetes environment.

## Set up the GKE cluster

The following two sections will show you how to spin up a Kubernetes cluster
using the `gcloud` command. See
[Google's docs](https://cloud.google.com/sdk/gcloud/reference/beta/container/clusters/create)
for more information on each parameter used.

Regardless of which option you choose, be sure to replace the following
parameters to reflect the needs of your workspace: `PROJECT_ID`,
`NEW_CLUSTER_NAME`, `ZONE`, and `REGION`. You can
[choose the zone and region](https://cloud.google.com/compute/docs/regions-zones#choosing_a_region_and_zone)
that makes the most sense for your location.

> Both options include the use of the `enable-network-policy` flag, which
> [creates a Calico cluster](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/calico-network-policy/).
> See See [Network Policies](../requirements.md#network-policies) for more
> information.

The sample scripts below create an `e2-standard-4` instance with 2 nodes for
evaluation purposes, with a configuration to auto-scale to 8 nodes as more
developer workspace pods are created. Depending on your needs, you can choose
other sizes. See [machine type
comparisons](https://cloud.google.com/compute/docs/machine-types#machine_type_comparison)
in particular [general-purpose machine types like n1 and
e2](https://cloud.google.com/compute/docs/general-purpose-machines). See
[requirements](../requirements.md) for help estimating your cluster size.

### Option 1: Cluster with full support of Coder features

This option uses an Ubuntu node image to enable support of
[Container-based Virtual Machines (CVMs)](../../admin/workspace-management/cvms.md),
allowing system-level functionalities such as Docker in Docker.

```console
gcloud beta container --project "$PROJECT_ID" \
    clusters create "$NEW_CLUSTER_NAME" \
    --zone "$ZONE" \
    --no-enable-basic-auth \
    --node-version "latest" \
    --cluster-version "latest" \
    --machine-type "e2-standard-4" \
    --image-type "ubuntu_containerd" \
    --disk-type "pd-standard" \
    --disk-size "50" \
    --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/cloud-platform" \
    --num-nodes "2" \
    --logging=SYSTEM,WORKLOAD \
    --monitoring=SYSTEM \
    --enable-ip-alias \
    --network "projects/$PROJECT_ID/global/networks/default" \
    --subnetwork "projects/$PROJECT_ID/regions/$REGION/subnetworks/default" \
    --default-max-pods-per-node "110" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing \
    --enable-autoupgrade \
    --enable-autorepair \
    --enable-network-policy \
    --enable-autoscaling \
    --min-nodes "1" \
    --max-nodes "8"
```

### Option 2: Cluster with minimum requirements for Coder

This option uses a Container-Optimized OS (COS) and meets Coder's minimum
requirements. It does _not_ enable the use of
[CVMs](../../admin/workspace-management/cvms.md).

```console
gcloud beta container --project "$PROJECT_ID" \
clusters create "$NEW_CLUSTER_NAME" \
   --zone "$ZONE" \
   --no-enable-basic-auth \
   --cluster-version "latest" \
   --machine-type "e2-standard-4" \
   --image-type "cos_containerd" \
   --disk-type "pd-standard" \
   --disk-size "50" \
   --metadata disable-legacy-endpoints=true \
   --scopes "https://www.googleapis.com/auth/cloud-platform" \
   --num-nodes "2" \
   --logging=SYSTEM,WORKLOAD \
   --monitoring=SYSTEM \
   --enable-ip-alias \
   --network "projects/$PROJECT_ID/global/networks/default" \
   --subnetwork "projects/$PROJECT_ID/regions/$REGION/subnetworks/default" \
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

## Access control

GKE allows you to integrate Identity Access and Management (IAM) with
Kubernetes' native Role-Based Access Control (RBAC) mechanism to authorize user
actions in the cluster. IAM configuration is primarily applied at the project
level and to all clusters within that project. Kubernetes RBAC configuration
applies to individual clusters, allowing you to implement fine-grained
authorization right down to the namespace level.

For more information, see:

- [GKE interaction with IAM](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#iam-interaction)
- [Kubernetes RBAC authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## Next steps

If you have already installed Coder, you can add this cluster as a [workspace
provider](../../admin/workspace-providers/deployment/index.md).

To access Coder through a secure domain, review our guides on configuring and
using [TLS certificates](../../guides/tls-certificates/index.md).

Once complete, see our page on [installation](../installation.md).
