---
title: Rancher Kubernetes Engine
description: Learn how to setup a Rancher cluster for your Coder deployment
---

This deployment guide shows you how to set up a bare-metal Rancher Kubernetes
Engine (RKE) cluster on which Coder can deploy.

## Prerequisites

You must have at least one Linux host (node) with the following utilities
installed:

### Binaries

- [Docker](https://docs.docker.com/engine/install/)
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [rke](https://rancher.com/docs/rke/latest/en/installation/)

### Storage

Since Coder requires dynamic storage provisioning, you'll need to
install a [Rancher-supported storage provisioner](https://rancher.com/docs/rancher/v2.5/en/cluster-admin/volumes-and-storage/provisioning-new-storage/#prerequisites).
We recommend using [Longhorn](https://longhorn.io/), since it is tightly
integrated with Rancher.

### Networking

Since the Coder default service is of `type: LoadBalancer`, we recommend
[installing MetalLB into your Rancher cluster](https://metallb.universe.tf/installation/).
You must install MetalLB prior to installing Coder for MetalLB to identify the
Coder service and [expose it externally](https://metallb.universe.tf/usage/).

## Setup

1. Once you've installed the necessary dependencies, create a `cluster.yml` file
to define the Rancher cluster configuration. Below is an example for a single-node
cluster:

```yaml
nodes:
    - address: 10.206.0.2
      user: ubuntu
      role:
        - controlplane
        - etcd
        - worker
      ssh_key_path: /home/ubuntu/.ssh/id_rsa
      ssh_agent_auth: true
```

> Ensure the user is a member of the docker group.

For a multi-node, high availability cluster, [see the Rancher documentation](https://rancher.com/docs/rke/latest/en/example-yamls/)
for additional configuration values.

1. Deploy the cluster with the following command:

```console
rke up --config cluster.yml
```

1. After the cluster is brought up, create your `kubeconfig` file and copy over the
Rancher-generated configuration:

```console
mkdir -p $HOME/.kube/ && cp kube_config_cluster.yml $HOME/.test/config
```

Once complete, you can now [install Coder](../installation.md) on to your
Rancher cluster.
