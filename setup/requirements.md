---
title: "Requirements"
description: Learn about the prerequisite infrastructure requirements.
---

Coder is deployed onto Kubernetes clusters, and we recommend the following
resource allocation minimums to ensure quality performance.

For **basic control services**, allocate at least 2 CPU cores, 4 GB of RAM, and
20 GB of storage.

You will also need to allocate additional CPU cores, RAM, and storage for
**each** active developer using Coder. The specific amount you should allocate
will vary based on your project, though you can use the following sets of
minimum requirements to help you estimate:

- Development using a JetBrains IDE: 4 CPU cores, 8 GB of RAM, and 10 GB of
  storage per developer
- Development using VS Code with an SSH connection to Coder: 1 CPU core and 1 GB
  of RAM per developer

> We recommend [monitoring](../guides/admin/usage-monitoring.md) your usage to
determine whether you should change your resource allocation.

### Throughput

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

Use an up-to-date browser to ensure that you can use all of Coder's features. We
currently require the following versions _or newer_:

- Apple Safari 12.1
- Google Chrome 66
- Mozilla Firefox 57
- Microsoft Edge 79

If you're using [Remote IDEs](../workspaces/editors.md), allow pop-ups; Coder
launches the Remote IDE in a pop-up window.

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

The use of Coder deployments requires a license that's emailed to you.

### Restrictions

Deployments using the free trial of Coder:

- **Must** be able to reach and use an outbound internet connection (at minimum,
  your deployment must be able to access **licensor.coder.com**)
- Cannot be deployed in an air-gapped network
- Must use Coder v1.10.0 or later

The above requirements do not apply to potential customers engaged in our
evaluation program.
