---
title: "K3s"
description: Set up K3s on an Ubuntu machine to deploy Coder.
---

This article will show you how to install K3s onto a new Ubuntu 20.04 LTS
machine for use with Coder.

[K3s](https://k3s.io/) is a lightweight Kubernetes distribution that works well
for single-node or multi-node clusters. This guide covers the installation
of K3s onto a new Ubuntu 20.04 LTS machine, but if you want to install Coder on
a local machine or an existing host, [Kind](./kind.md) or [k3d](https://k3d.io/)
are better choices.

> This installation method is not officially supported or tested by Coder. If
> you have questions or run into issues, feel free to reach out using our
> [community Slack channel](https://cdr.co/join-community).
>
> **We do not recommend using K3s for production deployments of Coder.**

## Prerequisites

Before proceeding, please make sure that:

1. You have an **Ubuntu 20.04 machine**: This can be a bare metal or a virtual
   machine. AWS EC2, GCP Compute Engine, Azure VMs, Vultr,
   and DigitalOcean all offer options that work well for cloud computing.

   Ensure that the machine's specs satisfy
   Coder's [resource requirements](../requirements.md), since your experience
   with Coder is dependent on your system specs.

1. You have the following software installed on your machine:
   - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
   - [helm](https://helm.sh/docs/intro/install/)

1. Your network policy or firewall accepts incoming traffic on:
   - Port 22 (SSH)
   - Port 80 (HTTP)
   - Port 443 (HTTPS)
   - Port 5349 (Networking v2 / TURN)
   - **Optional**: Port 8443 (Kubernetes API)

## Step 1: Change the default SSH port

To allow [SSH into
workspaces](https://coder.com/docs/coder/v1.20/workspaces/ssh), you must change
the host's default SSH port to free up port `22`. You may also need to modify
your firewall to accept incoming traffic from the alternative port (e.g., if you
rename port `22` to `5522`, then your firewall must accept traffic from `5522`).

> If you don't know how to change the SSH port in Linux, please review this
> [guide from Linuxize](https://linuxize.com/post/how-to-change-ssh-port-in-linux/)

## Step 2: Install K3s with Calico

The following steps are based on [Calico's quickstart
guide](https://docs.projectcalico.org/getting-started/kubernetes/k3s/quickstart)
for setting up K3s. However, you will disable K3s' default network policies and
Traefik in favor of Calico and nginx-ingress.

1. Create a single-node K3s cluster:

   ```console
   curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=192.168.0.0/16 --disable-network-policy --disable=traefik" sh -
   ```

   > Per the [Calico
   > docs](https://docs.projectcalico.org/getting-started/kubernetes/k3s/quickstart):
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
   kubectl create -f https://docs projectcalico.org/manifests tigera-operator.yaml

   kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
   ```

1. Confirm that all of the pods are running:

   ```console
   watch kubectl get pods --all-namespaces
   ```

## Step 3: Allow IP Forwarding

Modify Calico to enable IP forwarding, which is needed for container networking.

```console
vim /etc/cni/net.d/10-canal.conflist

kubectl edit cm cni-config -n calico-system
```

Under `container_settings`, set `allow_ip_forwarding` to `true`:

```json
"container_settings": {
   "allow_ip_forwarding": true
}
```

## Step 4: Copy over the kubeconfig

Occasionally, Helm will not recognize the K3s cluster
(see k3s-io/[k3s#1126](https://github.com/k3s-io/k3s/issues/1126) for more information).

If this happens, but you want to interface with the cluster from your local
machine, copy `/etc/rancher/k3s/k3s.yaml` to `~/.kube/config`.

After copying this file from the K3s node to your local workstation:

- Ensure that you replace `localhost` or `127.0.0.1` with the host's public IP
  address in the copied file
- Ensure that your firewall permits traffic through port `8443`

```console
# on the host machine:
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
```

## Next steps

At this point, you're ready to proceed to [installing Coder](../installation.md).
