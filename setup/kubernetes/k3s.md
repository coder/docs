---
title: "K3s"
description: Set up K3s on an Ubuntu machine to deploy Coder.
---

This article will show you how to install K3s onto a new Ubuntu 20.04 LTS
machine for use with Coder.

[K3s](https://k3s.io/) is a lightweight Kubernetes distribution that works well
for single-node or multi-node clusters. For single-user trial purposes, you may
want to consider the options in [Coder for Docker](../coder-for-docker/index.md).

> This installation method is not officially supported or tested by Coder. If
> you have questions or run into issues, feel free to reach out using our
> [community Slack channel](https://cdr.co/join-community).
>
> **We do not recommend using K3s for production deployments of Coder.**

## Prerequisites

Before proceeding, please make sure that:

- You have an **Ubuntu 20.04 machine**: This can be a bare metal or a virtual
  machine.

  Ensure that the machine's specs satisfy Coder's
  [resource requirements](../requirements.md), since your experience with Coder
  is dependent on your system specs.

- You have the following software installed on your machine:

  - [helm](https://helm.sh/docs/intro/install/)

- Your network policy or firewall accepts incoming traffic on:

  - Port 80 (HTTP)
  - Port 443 (HTTPS)
  - **Optional**: Port 6443 (Kubernetes API)

## Step 1: Install K3s with Calico

The following steps are based on
[Calico's quickstart guide](https://docs.projectcalico.org/getting-started/kubernetes/k3s/quickstart)
for setting up K3s. However, you will disable K3s' default network policies and
Traefik in favor of Calico and nginx-ingress.

1. Create a single-node K3s cluster:

   ```console
   curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=192.168.0.0/16 --disable-network-policy --disable=traefik" sh -
   ```

   > Per the
   > [Calico docs](https://docs.projectcalico.org/getting-started/kubernetes/k3s/quickstart):
   >
   > If `192.168.0.0/16` is already in use within your network, you must select
   > a different pod network CIDR by replacing `192.168.0.0/16` in the above
   > command.
   >
   > K3s installer generates kubeconfig file in `/etc` with limited permissions;
   > by using the `K3S_KUBECONFIG_MODE` environment, you are assigning the
   > necessary permissions to the file and making it accessible for other users.

1. Install the Calico operator and CRDs (Calico implements Kubernetes pod
   networking and policy enforcement):

   ```console
   kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml

   kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
   ```

1. Confirm that all of the pods are running:

   ```console
   watch kubectl get pods --all-namespaces
   ```

## Step 2: Allow IP Forwarding

Modify Calico to enable IP forwarding, which is needed for container networking.

```console
vim /etc/cni/net.d/10-calico.conflist

kubectl edit cm cni-config -n calico-system
```

Under `container_settings`, set `allow_ip_forwarding` to `true`:

```json
"container_settings": {
   "allow_ip_forwarding": true
}
```

## Step 3: Copy over the kubeconfig

Occasionally, Helm will not recognize the K3s cluster (see
k3s-io/[k3s#1126](https://github.com/k3s-io/k3s/issues/1126) for more
information).

If this happens, but you want to interface with the cluster from your local
machine, copy `/etc/rancher/k3s/k3s.yaml` to `~/.kube/config`.

After copying this file from the K3s node to your local workstation:

- Ensure that you replace `localhost` or `127.0.0.1` with the host's public IP
  address in the copied file
- Ensure that your firewall permits traffic through port `443`

```console
# on the host machine:
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
```

## Next steps

If you have already installed Coder, you can add this cluster as a [workspace
provider](../../admin/workspace-providers/deployment/index.md).

To access Coder through a secure domain, review our guides on configuring and
using [TLS certificates](../../guides/tls-certificates/index.md).

Once complete, see our page on [installation](../installation.md).
