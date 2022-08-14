---
title: Amazon Elastic Kubernetes Service
description:
  Learn how to set up an Amazon EKS cluster for your Coder deployment.
---

This deployment guide shows you how to set up an Amazon Elastic Kubernetes
Engine "EKS" cluster on which Coder can deploy.

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

See [Preliminary Steps](#preliminary-steps) and [Node Considerations](#node-considerations) first to familiarize yourself with steps and items before creating a cluster.

## Step 1: Create an EKS cluster

While flags can be passed to `eksctl create cluster`, the following example uses
a configuration yaml file to define an EKS cluster.

> The cluster name,
[region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-regions),
and SSH key path will be specific to your installation so potentially change
them in the yaml file


```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: trial-cluster
  region: us-east-1

managedNodeGroups:
  - name: managed-ng-1
    spot: true
    instanceType: t2.medium
    amiFamily: Ubuntu2004
    desiredCapacity: 1
    minSize: 1
    maxSize: 2
    volumeSize: 50
    ssh:
      allow: true
      publicKeyPath: ~/.ssh/id_rsa.pub
```

> If your developers require Docker commands like `docker build`, `docker run`, and `docker-compose` as
> part of their development flow, then [container-based virtual machines
> (CVMs)](../../workspaces/cvms.md) are required. `instantType` of `Ubuntu2004`
> is preferred since `AmazonLinux2` does not support caching and the shiftfs
> kernel module in CVM settings.

This example uses `t2.medium` instance with 2 nodes which is meant for a small deployment to trial Coder. Depending on
your needs, you can choose a
[larger size](https://aws.amazon.com/ec2/instance-types/) instead. See
[requirements](../requirements.md) for help estimating your cluster size.

When your cluster is ready, you should see the following message:

```console
EKS cluster "YOUR CLUSTER NAME" in "YOUR REGION" region is ready
```

This process may take ~15-30 minutes to complete since it is creating EC2 instance(s) aka node(s), node pool, a VPC, NAT Gateway, network interface, security group, elastic IP, EKS cluster, namespaces and pods.

> EKS creates a `volumeBindingMode` of `WaitForFirstConsumer`. See the
> [Kubernetes
> docs](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode)
> for more information. Coder accepts both `Immediate` and
> `WaitForFirstConsumer`.


## Step 2: (Optional) Install Calico onto your cluster

AWS uses
[Calico](https://docs.amazonaws.cn/en_us/eks/latest/userguide/calico.html) to
implement network segmentation and tenant isolation. For production deployments,
we recommend Calico to enforce workspace pod isolation; please see [Network
Policies](../requirements.md#network-policies) for more information.

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

## Cleanup | Delete EKS cluster

To delete the EKS cluster including any installation of Coder, substitute your cluster name and zone in the following `eksctl` command. This will take several minutes and can be monitored in the CloudFormation stack.

```console
eksctl delete cluster --region=us-east-1 --name=trial-cluster
```

## Preliminary steps

Before you can create a cluster, you'll need to perform the following to set up
and configure your AWS account.

1. Go to AWS' [EC2 console](https://console.aws.amazon.com/ec2/); this should
   take you to the EC2 page for the AWS region in which you're working (if not,
   change to the correct region using the dropdown in the top-right of the page)
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

If you have already installed Coder, you can add this cluster as a [workspace
provider](../../admin/workspace-providers/deployment/index.md).

To access Coder through a secure domain, review our guides on configuring and
using [TLS certificates](../../guides/tls-certificates/index.md).

Once complete, see our page on [Coder installation](../installation.md).
