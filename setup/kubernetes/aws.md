# Amazon Elastic Kubernetes Service

This deployment guide shows you how to set up an Amazon Elastic Kubernetes
Engine (EKS) cluster on which Coder can deploy.

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

## Step 1: Create an EKS cluster

While flags can be passed to `eksctl create cluster`, the following example uses
an [`eksctl` configuration file](https://eksctl.io/usage/schema/) to define the
EKS cluster.

> The cluster name,
> [region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones>.html#concepts-regions),
> and SSH key path will be specific to your installation.

```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: coder-trial-cluster
  region: us-east-1

managedNodeGroups:
  - name: managed-ng-1
    instanceType: t2.medium
    amiFamily: Ubuntu2004
    desiredCapacity: 1
    minSize: 1
    maxSize: 2
    volumeSize: 100
    ssh:
      allow: true
      publicKeyPath: ~/.ssh/id_rsa.pub
```

This example uses `t2.medium` instance with 2 nodes which is meant for a small
trial deployment. Depending on your needs, you can choose a
[larger size](https://aws.amazon.com/ec2/instance-types/) instead. See our
documentation on [resources](../../guides/admin/resources.md) and
[requirements](../requirements.md) for help estimating your cluster size.

 > If your developers require Docker commands like `docker build`, `docker run`,
 > and `docker-compose` as part of their development flow, then
 > [container-based virtual machines (CVMs)](../../workspaces/cvms.md) are
 > required. In this case, we recommend using the `Ubuntu2004` AMI family, as
 > the `AmazonLinux2` AMI family does not meet the requirements
 > for [cached CVMs](../../workspace-management/cvms/management#caching).

Once the file is ready, run the following command to create the cluster:

```console
eksctl create cluster -f cluster.yaml
```

This process may take ~15-30 minutes to complete since it is creating EC2
instance(s) aka node(s), node pool, a VPC, NAT Gateway, network interface,
security group, elastic IP, EKS cluster, namespaces and pods.

> By default, EKS creates a `volumeBindingMode` of `WaitForFirstConsumer`. See the
> [Kubernetes docs](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode)
> for more information on this mode. Coder accepts both `Immediate` and `WaitForFirstConsumer`.

When your cluster is ready, you should see the following message:

```console
EKS cluster "YOUR CLUSTER NAME" in "YOUR REGION" region is ready
```

## Step 2: (Optional) Install Calico onto your cluster

AWS uses [Calico](https://docs.amazonaws.cn/en_us/eks/latest/userguide/calico.html)
to implement network segmentation and tenant isolation. For production deployments,
we recommend Calico to enforce workspace pod isolation; please see [Network Policies](../requirements.md#network-policies)
for more information.

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

To delete the EKS cluster including any installation of Coder, substitute your
cluster name and zone in the following `eksctl` command. This will take several
minutes and can be monitored in the CloudFormation stack.

```console
eksctl delete cluster --region=us-east-1 --name=trial-cluster
```

## Next steps

If you have already installed Coder, you can add this cluster as a [workspace
provider](../../admin/workspace-providers/deployment/index.md).

To access Coder through a secure domain, review our guides on configuring and
using [TLS certificates](../../guides/tls-certificates/index.md).

Once complete, see our page on [Coder installation](../installation.md).
