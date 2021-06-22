---
title: "k3s"
description: Set up a Coder deployment with a Ubuntu + k3s
---

k3s is a lightweight Kubernetes distribution that works well for single-node or
multi-node clusters alike.

This guide covers installation on a new Ubuntu 20.04 LTS machine. If you are
looking to install Coder on a local machine or an existing host,
[Kind](./kind.md) or k3d may be a better choice.

> This install method is not officially supported or tested by Coder. If you
> have questions or run into issues, feel free to reach out on our
> [community Slack channel](https://cdr.co/join-community).

## Prerequisites

Before proceeding, please make sure that you have the following:

1. **Ubuntu 20.04 machine**: This can be a bare metal or virtual machine. For
   cloud compute, AWS EC2, GCP Compute Engine, Azure VMs, Vultr, DigitalOcean
   work well. Make sure the machine specs satisfies Coder's
   [resource requirements](../requirements.md)
1. Network policy or firewall accepting incoming traffic on ports 22 (SSH), 80
   (HTTP), 443 (HTTPS), and 8443 (Kubernetes API).
1. The following software installed on the machine:
   - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
   - [helm](https://helm.sh/docs/intro/install/)

### Resource allocation and performance

Your experience with Coder is dependent on your system specs. See our
[resource requirements](../requirements.md) for more details.

## Change the default SSH port

If you want to allow
[SSH into workspaces](https://coder.com/docs/coder/v1.20/workspaces/ssh), you
will need to change the host's default SSH port to free up port 22. You may also
need to modify your firewall to accept incoming traffic from the alternative
port (e.g 5522)

[Follow this guide](https://linuxize.com/post/how-to-change-ssh-port-in-linux/)
by Linuxize if you do not know how to do this.

## Install k3s with Calico

The following uses
[Calico's quickstart guide](https://docs.projectcalico.org/getting-started/kubernetes/k3s/quickstart)
to set up K3s. We will be disabling the default network policies and Traefik in
favor of Calico and nginx-ingress.

1. Create a single-node k3s cluster.

   ```console
   curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=192.168.0.0/16 --disable-network-policy --dis55able=traefik" sh -
   ```

   > From the
   > [Calico docs](https://docs.projectcalico.org/getting-started/kubernetes/k3s/quickstart):
   >
   > If 192.168.0.0/16 is already in use within your network you must select a
   > different pod network CIDR by replacing 192.168.0.0/16 in the above
   > command.
   >
   > K3s installer generates kubeconfig file in etc directory with limited
   > permissions, using K3S_KUBECONFIG_MODE environment you are assigning
   > necessary permissions to the file and make it accessible for other users.

1. Install the Calico operator and CRDs

   Calico is used to implement network segmentation and tenant isolation.

   ```console
   kubectl create -f https://docs projectcalico.org/manifests tigera-operator.yaml

   kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
   ```

1. Confirm all of the pods are running

   ```console
   watch kubectl get pods --all-namespaces
   ```

## Allow IP Forwarding

IP forwarding is necessary for container networking. Modify Calico so that IP
forwarding is allowed in the container_settings section.

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

### Copy your kubeconfig

Sometimes helm will not properly recognize the k3s cluster
(k3s-io/[k3s#1126](https://github.com/k3s-io/k3s/issues/1126)).

```console
# on the host machine:
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
```

If you want to interface with the cluster from your local machine,,
`/etc/rancher/k3s/k3s.yaml` to `~/.kube/config` on your local machine. Replace
localhost or 127.0.0.1 with the host's public IP address.

## Next steps

At this point, you're ready to proceed to [installation](../installation.md).
