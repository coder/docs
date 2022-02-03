---
title: Podman
description: Learn how to run Podman in Coder.
---

This article will walk you through setting up
[Podman](https://docs.podman.io/en/latest/) for use in Coder workspaces

Podman is a container engine (similar to Docker) that is compatible with the OCI
containers specification. Podman is useful if you'd like an alternative to
[CVM workspaces](../../admin/workspace-management/cvms/index.md) or if your
Linux kernel doesn't support CVMs.

> Please be aware that there are
> [limitations related to running Podman in rootless mode](https://github.com/containers/podman/blob/main/rootless.md#shortcomings-of-rootless-podman).

> **Note**: Running Podman in rootless mode requires a FUSE device to implement
> the overlay filesystem (fuse-overlayfs) in unprivileged mode. The following
> directions work by mounting the FUSE device from the host into workspace
> containers, which conflicts with the isolation provided by SELinux and
> AppArmor.
>
> For systems running AppArmor (typically Debian- and Ubuntu-derived systems),
> please disable AppArmor before proceeding.
>
> For systems running SELinux (typically Fedora-, CentOS-, and Red Hat-based
> systems), please disable SELinux or set it to `permissive` mode.

1. Install `smarter-device-manager` and expose the FUSE device through it. To do
   so, create a file called `smarter-device-manager.yaml` with the following
   contents:

   ```yaml
   apiVersion: v1
   kind: Namespace
   metadata:
     name: smarter-device-manager
     labels:
       name: smarter-device-manager

   ---
   apiVersion: v1
   kind: ResourceQuota
   metadata:
     name: smarter-device-manager
     namespace: smarter-device-manager
   spec:
     hard:
       pods: 50
     scopeSelector:
       matchExpressions:
         - operator: In
           scopeName: PriorityClass
           values:
             - system-node-critical
             - system-cluster-critical

   ---
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: smarter-device-manager
     namespace: smarter-device-manager
   data:
     conf.yaml: |+
       - devicematch: ^fuse$
         nummaxdevices: 50

   ---
   apiVersion: apps/v1
   kind: DaemonSet
   metadata:
     name: smarter-device-manager
     namespace: smarter-device-manager
     labels:
       name: smarter-device-manager
       role: agent
   spec:
     selector:
       matchLabels:
         name: smarter-device-manager
     updateStrategy:
       type: RollingUpdate
     template:
       metadata:
         labels:
           name: smarter-device-manager
         annotations:
           node.kubernetes.io/bootstrap-checkpoint: "true"
       spec:
         nodeSelector:
           smarter-device-manager: enabled
         priorityClassName: "system-node-critical"
         hostname: smarter-device-management
         hostNetwork: true
         dnsPolicy: ClusterFirstWithHostNet
         containers:
           - name: smarter-device-manager
             image: registry.gitlab.com/arm-research/smarter/smarter-device-manager:v1.20.7
             imagePullPolicy: IfNotPresent
             securityContext:
               allowPrivilegeEscalation: false
               capabilities:
                 drop: ["ALL"]
             resources:
               limits:
                 cpu: 100m
                 memory: 15Mi
               requests:
                 cpu: 10m
                 memory: 15Mi
             volumeMounts:
               - name: device-plugin
                 mountPath: /var/lib/kubelet/device-plugins
               - name: dev-dir
                 mountPath: /dev
               - name: sys-dir
                 mountPath: /sys
               - name: config
                 mountPath: /root/config
         volumes:
           - name: device-plugin
             hostPath:
               path: /var/lib/kubelet/device-plugins
           - name: dev-dir
             hostPath:
               path: /dev
           - name: sys-dir
             hostPath:
               path: /sys
           - name: config
             configMap:
               name: smarter-device-manager
         terminationGracePeriodSeconds: 30
   ```

   Next, apply the changes to your clusters by running:

   ```console
   kubectl apply -f ./smarter-device-manager.yaml
   ```

   The example `DaemonSet` includes a `nodeSelector` that constrains the
   device plugin to nodes with the `smarter-device-manager` label set to
   `enabled`. Label the nodes that will include the FUSE device by using the
   following command, or remove the `nodeSelector` from the manifest:

   ```console
   kubectl get nodes
   kubectl label node <node name> smarter-device-manager=enabled
   ```

1. If you haven't already done so for your Coder deployment, enable workspace
   templates. To do so, go to **Manage** > **Admin** > **Templates**, and set
   the **Enable workspace templates** to **On**. Click **Save**.

1. Create a YAML file with the following contents (the instructions ask the
   cluster to request the FUSE device for each workspace):

   ```yaml
   version: "0.2"
   workspace:
       configure:
           start:
               policy: write
       dev-urls:
           policy: write
       specs:
           aws-ec2-docker:
               container-image:
                   policy: write
               disk-size:
                   policy: write
               instance-type:
                   policy: write
           docker:
               container-based-vm:
                   policy: write
               image:
                   policy: write
           kubernetes:
               annotations:
                   policy: read
               container-based-vm:
                   policy: write
               cpu:
                   policy: write
               disk:
                   policy: write
               env:
                   policy: write
               gpu-count:
                   policy: write
               image:
                   policy: write
               labels:
                   policy: read
               memory:
                   policy: write
               node-selector:
                   policy: read
               privileged:
                   policy: read
               resource-requests:
                   policy: write
                   value:
                       smarter-devices/fuse: "1"
               resource-limits:
                   policy: write
                   value:
                       smarter-devices/fuse: "1"
               runtime-class-name:
                   policy: read
               tolerations:
                   policy: read
   ```

1. In the Coder UI, navigate to **Manage** > **Admin** > **Templates** if you
   haven't already done so. Under **template policy**, upload the configuration
   file you created in the previous step. Click **Save**.

   With the above template policy, all workspaces will acquire a FUSE device,
   which enables Podman to operate in rootless mode.

## Testing

At this point, you can create a workspace that leverages Podman. If you need a
sample Podman image, you can obtain one
[from RedHat](https://quay.io/repository/podman/stable?tag=latest&tab=tags).
When using this image, switch to the unprivileged `podman` user before creating
containers to ensure that `podman` runs in rootless mode.
