# System Requirements

Coder is deployed into a Kubernetes cluster namespace. We recommend the
following resource minimums to ensure quality performance.

## Compute

For the Coder control plane (which consists of the `coderd` pod and any
additional replicas) allocate at least 2 CPU cores, 4 GB of RAM, and 20 GB of
storage.

In addition to sizing the control plane node(s), you can configure the `coderd`
pod's resource requests/limits and number of replicas in the [Helm
chart](https://github.com/coder/enterprise-helm/blob/main/values.yaml). The
current defaults for both CPU and memory are the following:

```yaml
coderd:
  resources:
    requests:
      cpu: "250m"
      memory: "512Mi"
    limits:
      cpu: "500m"
      memory: "512Mi"
```

By default, Coder is a single-replica deployment. For larger evaluations and
production systems, consider increasing the number of nodes and using at least
two to three coderd replicas to provide failover and load balancing
capabilities.

If you expect roughly ten or more concurrent users, we recommend increasing
these figures to improve platform performance (we also recommend regular
performance testing in a staging environment).

See [Scaling](./scaling.md) for more information.

For **each** active developer using Coder, allocate additional resources. The
specific amount required per developer varies, though we recommend starting with
4 CPUs and 4 GB of RAM, especially when JetBrains IDEs are used and which are
resource intensive. Developers are free to request the resource allocation that
fits their usage:

![Workspace resource request](../assets/setup/resource-request.png)

Administrators can put limits aka [Resource Quotas at the
Organization-level](../admin/organizations/manage#create-a-new-organization) to
prevent developers from using excessive compute that is either cost prohibitive
and/or destructive to the health of the Kubernetes cluster.

We also recommend [monitoring](../guides/admin/usage-monitoring.md) your usage
to determine whether you should change your resource allocation. Accepting a
utilization of RAM of around 50% and CPU of around 70% is a good way to balance
performance with cost.

## Throughput

We recommend the following throughput:

- Read: 3000 IOPS at 50 MB/s
- Write: 3000 IOPS at 50 MB/s

## Enabled extensions

You must enable the following extensions on your K8 cluster (check whether you
have these extensions enabled by running `kubectl get apiservices`):

- apps/v1
- rbac.authorization.k8s.io/v1
- metrics.k8s.io
- storage.k8s.io/v1
- networking.k8s.io/v1
- extensions/v1beta1

## Browsers

Use an up-to-date browser to ensure that you can use all of Coder's features.
Coder runs on the following browsers:

- Apple Safari
- Google Chrome
- Mozilla Firefox
- Microsoft Edge

> We have noticed periodic user interface issues with Apple Safari so if you
> experience difficulties, please use another browser type.

If you're using [Remote IDEs](../workspaces/editors.md), allow pop-ups; Coder
launches the Web Terminal and Remote IDE in pop-up windows.

## Storage

Coder requires the use of a
[persistent volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
in your Kubernetes cluster to store [workspaces](../workspaces/index.md) data.
More specifically, the persistent volume claim (PVC) requires the block storage
type (the PVC is created when you create the workspace to mount the requested
block storage).

Files stored in the `/home` directory of a workspace are persisted in the PVC.
All files that live _outside_ of the `/home` directory are written to the node's
disk storage (the node's disk storage is shared across all workspaces on that
node). If there's insufficient node disk storage, Coder cannot create new
workspaces (and, in some cases, workspaces may be evicted from the node). To
avoid this, we recommend creating nodes with a disk size of at least 100 GiB.

Additionally, you must enable
[dynamic volume provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/#enabling-dynamic-provisioning)
so that Coder can mount the PVC to the workspace (if you're using a custom
`StorageClass`, be sure that it supports DVP. Otherwise, Coder cannot provision
workspaces).

> If you are running a multi-zone deployment, ensure that you have at least one
> node in each zone to prevent volume node affinity conflicts.

## Database

Coder requires a [PostgreSQL](https://www.postgresql.org) database to store
metadata related to your deployment.

By default, Coder deploys a TimescaleDB internal to your Kubernetes cluster.
This is included for evaluation purposes _only_, and it is _not_ backed up. For
production deployments, we recommend using a PostgreSQL database _external_ to
your cluster. You can connect Coder to your external database by
[modifying the Helm chart](../guides/admin/helm-charts.md) with information
regarding your PostgreSQL instance.

Coder requires, at minimum, PostgreSQL 11 with the `contrib` package installed.

## Network Policies

Coder uses
[Kubernetes NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
to enforce network segmentation and tenant isolation within your cluster.

Coder's network isolation policy blocks all ingress traffic to workspaces except
traffic from the control plane (this ensures that you can audit all traffic).
However, the control plane does not specify egress rules; by default, it allows
outbound traffic. However, you can still enforce a more specific network policy.

[Container network interface (CNI)](https://github.com/containernetworking/cni#what-is-cni)
plugins implement network segmentation and tenant isolation in the Kubernetes
cluster. They enforce network boundaries between pods, preventing users from
accessing other workspaces.

If your container network interface (CNI) plugin does not support NetworkPolicy
enforcement, traffic between workspaces, and other containerized workloads
within the same cluster will be permitted to communicate without restriction.
Consider testing your container networking _after_ installing Coder to ensure
that the behavior is as expected.

> If you're not sure which CNI plugin to use, we suggest
> [Calico](https://docs.projectcalico.org/getting-started/kubernetes/quickstart).

## Licenses

The use of Coder deployments requires a license that's emailed to you. Save as a
json file and see [Setup](./configuration#providing-your-license) for how to
add a license file into a Coder deployment.

### Restrictions

Deployments using the free trial of Coder:

- **Must** be able to reach and use an outbound internet connection (at minimum,
  your deployment must be able to access **licensor.coder.com**)
- Cannot be deployed in an air-gapped network

<<<<<<< HEAD
If you are an enterprise and require Coder to run in an air-gapped network,
please contact sales@coder.com to discuss your project.
=======
> Coder's trial license does not work in an air-gapped environment. If your
> organization is interested in evaluating Coder air-gapped, please contact
> [sales@coder.com](mailto:sales@coder.com) to discuss license requirements.
>>>>>>> main
