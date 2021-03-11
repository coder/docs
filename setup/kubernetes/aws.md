---
title: Amazon Elastic Kubernetes Service
description: Learn how to set up an Amazon EKS cluster for your Coder deployment.
---

This deployment guide shows you how to set up an Amazon Elastic Kubernetes
Engine cluster on which Coder can deploy.

## Prerequisites

Please make sure that you have the following utilities installed on your
machine:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [AWS Command Line
  Interface](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
  (you'll also need to
  [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
  the command-line interface to interact with your AWS account; consider AWS'
  [CLI configuration
  quickstart](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
  to fast-track this process
- [eksctl command line
  utility](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

## Preliminary Steps

Before you can create a cluster, you'll need to perform the following to set up
and configure your AWS account.

1. Go to AWS' [EC2 Console](https://console.aws.amazon.com/ec2/); this should
   take you to the EC2 page for the AWS region in which you're working (if not,
   change to the correct region using the dropdown in the top-right of the page)
2. In the **Resources** section in the middle of the page, click **Elastic
   IPs**.
3. Choose either an Elastic IP address you want to use or click **Allocate
   Elastic IP address**. Choose **Amazon's pool of IPv4 addresses** and click
   **Allocate**.
4. Return to the EC2 Dashboard.
5. In the **Resources** section in the middle of the page, click **Key Pairs**.
6. Click **Create key pair** (alternatively, if you already have a local SSH key
   you'd like to use, you can click the Actions dropdown and import your key)
7. Provide a **name** for your key pair and select **pem** as your **file
   format**. Click **Create key pair**.
8. You'll automatically download the keypair; save it to a known directory on
   your local machine (we recommend keeping the default name, which will match
   the name you provided to AWS).
9. Now that you have the `.pem` file locally extract the public key portion of
   the keypair so that you can use it with the eksctl CLI in later steps:

   ```sh
   ssh-keygen -y -f <PATH/TO/KEY>.pem >> <PATH/TO/KEY/KEY>.pub
   ```

  **Note**: if you run into a bad permissions error, run sudo before the command
  above.
  
  When done, you should have a .pem and .pub file for the same keypair you
  downloaded from AWS

## Step 1: Spin up a K8 Cluster

The following will spin up a Kubernetes cluster using the `eksctl`; replace the
parameters and environment variables as needed to reflect those for your
environment.

```bash
CLUSTER_NAME="YOUR_CLUSTER_NAME" \
  SSH_KEY_PATH="<PATH/TO/KEY>.pub" REGION="YOUR_REGION" \
  eksctl create cluster \
  --name "$CLUSTER_NAME" \
  --version 1.17 \
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

> Please note that the sample script creates a `t3.medium` instance; depending
on your needs, you can choose a [larger
size](https://aws.amazon.com/ec2/instance-types/t3/) instead.

When your cluster is ready, you should see the following message:

```bash
EKS cluster "YOUR_CLUSTER_NAME" in "YOUR_REGION" region is ready
```

## Step 2: Adjust the K8 Storage Class

Once you've created the cluster, adjust the default Kubernetes storage class to
support immediate volume binding.

1. Make sure that you're pointed to the correct context:

   ```bash
   kubectl config current-context
   ```

2. If you're pointed to the correct context, delete the gp2 storage class:

   ```bash
   kubectl delete sc gp2
   ```

3. Recreate the gp2 storage class with the `volumeBindingMode` set to
   `Immediate`:

   ```bash
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

> See the [Kubernetes
> docs](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode)
> for information on choosing the right parameter for `volumeBindingMode`; Coder
> accepts both `Immediate` and `WaitForFirstConsumer`.

### Modifying Your Cluster to Support CVMs

To create clusters allowing you to [enable container-based virtual machines
(CVMs)](../../admin/environment-management/cvms.md) as an environment deployment
option, you'll need to [create a
nodegroup](https://eksctl.io/usage/managing-nodegroups/#creating-a-nodegroup-from-a-config-file).

1. Define your config file (we've named the file `coder-node.yaml`, but you can
   call it whatever you'd like):

    ```yaml
    apiVersion: eksctl.io/v1alpha5
    kind: ClusterConfig

    metadata: 
      version: "1.17"
      name: <YOUR_CLUSTER_NAME>
      region: <YOUR_AWS_REGION>

    nodeGroups:
    - name: coder-node-group
      amiFamily: Ubuntu1804
    ```

2. Create your nodegroup (be sure to provide the correct file name):

    ```bash
    eksctl create nodegroup --config-file=coder-node.yaml
    ```

## Step 3: Install Calico onto Your Cluster

AWS uses
[Calico](https://docs.amazonaws.cn/en_us/eks/latest/userguide/calico.html) to
implement network segmentation and tenant isolation.

1. Apply the Calico manifest to your cluster:

   ```bash
   kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/v1.7.5/config/v1.7/calico.yaml
   ```

1. Watch the `kube-system` DaemonSets:

   ```bash
   kubectl get daemonset calico-node --namespace kube-system
   ```

   Wait for the `calico-node` DaemonSet to have the number of pods **desired**
   in the **ready** state; this indicates that Calico is working:

   ```bash
   NAME          DESIRED   CURRENT   READY     UP-TO-DATE   ...
   calico-node   3         3         3         3            ...
   ```

## Access Control

Amazon EKS allows for creating and managing user permissions via IAM identity providers
(IdPs). Additionally, EKS supports user authentication via OpenID Connect (OIDC)
identity providers. Using IAM in tandem with Kubernetes' native Role-Based Access
Control (RBAC), allows you to grant access to your EKS cluster using existing IdPs,
and configure fine-grain permissions within each cluster via RBAC.

For more information, see [Using Kubernetes RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
and [AWS Identity Providers and Federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers.html).

## Next Steps

At this point, you're ready to proceed to [Installation](../installation.md).
