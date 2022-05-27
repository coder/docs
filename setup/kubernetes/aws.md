---
title: Amazon Elastic Kubernetes Service
description:
  Learn how to set up an Amazon EKS cluster for your Coder deployment.
---

This deployment guide shows you how to set up an Amazon Elastic Kubernetes
Engine cluster on which Coder can deploy.

## Prerequisites

Please make sure that you have the following utilities installed on your
machine:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [AWS command-line interface](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
  (you'll also need to
  [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
  the command-line interface to interact with your AWS account; consider AWS'
  [CLI configuration quickstart](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
  to fast-track this process
- [eksctl command-line utility](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

## Node Considerations

The node type and size that you select impact how you use Coder. When choosing,
be sure to account for the number of developers you expect to use Coder, as well
as the resources they need to run their workspaces. See our guide on on
[compute resources](../../guides/admin/resources.md) for additional information.

If you expect to provision GPUs to your Coder workspaces, you **must** use an
EC2 instance from AWS'
[accelerated computing instance family](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/accelerated-computing-instances.html).

> GPUs are not supported in workspaces deployed as
> [container-based virtual machines (CVMs)](../../workspaces/cvms.md) unless
> you're running Coder in a bare-metal Kubernetes environment.

## Preliminary steps

Before you can create a cluster, you'll need to perform the following to set up
and configure your AWS account.

1. Go to AWS' [EC2 console](https://console.aws.amazon.com/ec2/); this should
   take you to the EC2 page for the AWS region in which you're working (if not,
   change to the correct region using the dropdown in the top-right of the page)
1. In the **Resources** section in the middle of the page, click **Elastic
   IPs**.
1. Choose either an Elastic IP address you want to use or click **Allocate
   Elastic IP address**. Choose **Amazon's pool of IPv4 addresses** and click
   **Allocate**.
1. Return to the EC2 Dashboard.
1. In the **Resources** section in the middle of the page, click **Key Pairs**.
1. Click **Create key pair** (alternatively, if you already have a local SSH key
   you'd like to use, you can click the Actions dropdown and import your key)
1. Provide a **name** for your key pair and select **pem** as your **file
   format**. Click **Create key pair**.
1. You'll automatically download the keypair; save it to a known directory on
   your local machine (we recommend keeping the default name, which will match
   the name you provided to AWS).
1. Now that you have the `.pem` file, extract the public key portion of the
   keypair so that you can use it with the eksctl CLI in later steps:

   ```sh
   ssh-keygen -y -f <PATH/TO/KEY>.pem >> <PATH/TO/KEY/KEY>.pub
   ```

   **Note**: if you run into a bad permissions error, run `sudo` before the
   command above.

When done, you should have a .pem and .pub file for the same keypair you
downloaded from AWS.

## Step 1: Spin up a K8s cluster

To make subsequent steps easier, start by creating environment variables for the
cluster name,
[region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-regions),
and SSH key path:

```console
CLUSTER_NAME="YOUR_CLUSTER_NAME"
SSH_KEY_PATH="<PATH/TO/KEY>.pub"
REGION="YOUR_REGION"
```

The following will spin up a Kubernetes cluster using `eksctl` (be sure to
update the parameters as necessary, especially the version number):

```console

  eksctl create cluster \
  --name "$CLUSTER_NAME" \
  --version <version> \
  --region "$REGION" \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 2 \
  --nodes-max 8 \
  --ssh-access \
  --ssh-public-key "$SSH_KEY_PATH" \
  --managed
```

Please note that the sample script creates a `t3.medium` instance; depending on
your needs, you can choose a
[larger size](https://aws.amazon.com/ec2/instance-types/t3/) instead. See
[requirements](../requirements.md) for help estimating your cluster size.

When your cluster is ready, you should see the following message:

```console
EKS cluster "YOUR_CLUSTER_NAME" in "YOUR_REGION" region is ready
```

This process may take ~15-30 minutes to complete.

## Step 2: Adjust the K8s storage class

Once you've created the cluster, adjust the default Kubernetes storage class to
support immediate volume binding.

1. Make sure that you're pointed to the correct context:

   ```console
   kubectl config current-context
   ```

1. If you're pointed to the correct context, delete the gp2 storage class:

   ```console
   kubectl delete sc gp2
   ```

1. Recreate the gp2 storage class with the `volumeBindingMode` set to
   `Immediate`:

   ```console
   cat <<EOF | kubectl apply -f -
   apiVersion: storage.k8s.io/v1
   kind: StorageClass
   metadata:
     annotations:
       storageclass.kubernetes.io/is-default-class: "true"
     name: gp2
   provisioner: kubernetes.io/aws-ebs
   parameters:
     type: gp2
     fsType: ext4
   volumeBindingMode: Immediate
   allowVolumeExpansion: true
   EOF
   ```

> See the
> [Kubernetes docs](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode)
> for information on choosing the right parameter for `volumeBindingMode`; Coder
> accepts both `Immediate` and `WaitForFirstConsumer`.

### Modifying your cluster to support CVMs

To create clusters allowing you to
[enable container-based virtual machines (CVMs)](../../admin/workspace-management/cvms.md)
as a workspace deployment option, you'll need to
[create a nodegroup](https://eksctl.io/usage/eks-managed-nodes/#creating-managed-nodegroups).

1. Define your config file (we've named the file `coder-node.yaml`, but you can
   call it whatever you'd like):

   ```yaml
   apiVersion: eksctl.io/v1alpha5
   kind: ClusterConfig

   metadata:
     version: "<YOUR_K8s_VERSION>"
     name: <YOUR_CLUSTER_NAME>
     region: <YOUR_AWS_REGION>

   managedNodeGroups:
     - name: coder-node-group
       amiFamily: Ubuntu2004
       # Custom EKS-compatible AMIs can be used instead of amiFamily
       # ami: <your Ubuntu 20.04 AMI ID>
       instanceType: <instance-type>
       minSize: 1
       maxSize: 2
       desiredCapacity: 1
       # Uncomment "overrideBootstrapCommand" if you are using a custom AMI
       # overrideBootstrapCommand: |
       #  #!/bin/bash -xe
       #  sudo /etc/eks/bootstrap.sh <YOUR_CLUSTER_NAME>
   ```

> [See here for a list of EKS-compatible Ubuntu AMIs](https://cloud-images.ubuntu.com/docs/aws/eks/)

1. Create your nodegroup (be sure to provide the correct file name):

   ```console
   eksctl create nodegroup --config-file=coder-node.yaml
   ```

## Step 3: (Optional) Install Calico onto your cluster

AWS uses
[Calico](https://docs.amazonaws.cn/en_us/eks/latest/userguide/calico.html) to
implement network segmentation and tenant isolation.

1. Apply the Calico manifest to your cluster:

   ```console
   kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-operator.yaml
   kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-crs.yaml
   ```

1. Watch the `calico-system` DaemonSets:

   ```console
   kubectl get daemonset calico-node --namespace calico-system
   ```

   Wait for the `calico-node` DaemonSet to have the number of pods **desired**
   in the **ready** state; this indicates that Calico is working:

   ```console
   NAME          DESIRED   CURRENT   READY     UP-TO-DATE   ...
   calico-node   3         3         3         3            ...
   ```

## Access control

EKS allows you to create and manage user permissions using IAM identity
providers (IdPs). EKS also supports user authentication via OpenID Connect
(OIDC) identity providers.

Using IAM with Kubernetes' native Role-Based Access Control (RBAC) allows you to
grant access to your EKS cluster using existing IDPs and fine-tune permissions
with RBAC.

For more information, see:

- [AWS identity providers and federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers.html)
- [Kubernetes RBAC authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## Next steps

If you have already installed Coder or are using our hosted beta, you can add
this cluster as a
[workspace provider](../../admin/workspace-providers/deployment/index.md).

To access Coder through a secure domain, review our guides on configuring and
using [TLS certificates](../../guides/tls-certificates/index.md).

Once complete, see our page on [installation](../installation.md).
