---
title: "k3s"
description: Set up a Coder deployment with a Ubuntu + k3s
---

k3s is a lightweight Kubernetes distribution that works great with single-node
or multi-node clusters alike.

> This guide only covers installation on a new Ubuntu 20.04 LTS machine. If you
> are looking to install on a local machine or an existing host,
> [Kind](./kind.md) or k3d may be a better choice.

## Prerequisites

Before proceeding, please make sure that you have the following:

1. **Ubuntu 20.04 machine**: This can be a bare metal or virtual machine. For
   cloud compute, AWS EC2, GCP Compute Engine, Azure VMs, Vultr, or DigitalOcean
   all work. Make sure the machine specs satisfies Coder's
   [resource requirements](../requirements.md)
1. Network policy exposting ports 22, 80, 443, and 5522 (alternative SSH port)
1. The following software installed on the machine:
   - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
   - [helm](https://helm.sh/docs/intro/install/)

### Resource allocation and performance

Your experience with Coder is dependent on your system specs. See our
[resource requirements](../requirements.md) for more details.

## Change the default SSH port

If you want to allow
[SSH into workspaces](https://coder.com/docs/coder/v1.20/workspaces/ssh), you
will need to change the host's default SSH port to free up port 22.

[Follow this guide](https://linuxize.com/post/how-to-change-ssh-port-in-linux/)
by Linuxize if you do not know how to do this.

## Install k3s with Calico

1. Create a single-node k3s cluster

   ```console
   curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=192.168.0.0/16 --disable-network-policy --disable=traefik" sh -
   ```

1. Install the Calico operator and CRDs

   ```console
   kubectl create -f https://docs projectcalico.org/manifests tigera-operator.yaml

   kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
   ```

1. Confirm all of the pods are running

   ```console
   watch kubectl get pods --all-namespaces
   ```

See the
[Calico docs](https://docs.projectcalico.org/getting-started/kubernetes/k3s/quickstart)
for a more detailed tutorial and troubleshooting info.

## Allow IP Forwarding

Modify Calico so that IP forwarding is allowed in the container_settings
section.

Edit the value in the following places:

```console
vim /etc/cni/net.d/10-canal.conflist

kubectl edit cm cni-config -n calico-system
```

```json
"container_settings": {
   "allow_ip_forwarding": true
}
```

### Ensure `$KUBECONFIG` is defined

Sometimes helm will not properly recognize the k3s cluster
(k3s-io/[k3s#1126](k3s#1126)). To resolve this, add the following to your
`~/.bashrc`:

```console
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml`
```

## Next steps

At this point, you're ready to proceed to [installation](../installation.md).
