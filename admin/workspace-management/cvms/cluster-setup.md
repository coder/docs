---
title: Cluster setup
description: Learn how to set up K8s clusters capable of supporting CVMs.
---

The following sections show how you can set up your Kubernetes clusters hosted
by Google, Azure, and Amazon to support CVMs.

## Google Cloud Platform w/ GKE

To use CVMs with GKE, [create a cluster](../../setup/kubernetes/google.md) using
the following parameters:

- GKE Master version `latest`
- `node-version = "latest"`
- `image-type = "UBUNTU"`

For example:

```console
gcloud beta container clusters create "YOUR_NEW_CLUSTER" \
    --node-version "latest" \
    --cluster-version "latest" \
    --image-type "UBUNTU"
    ...
```

## Azure Kubernetes Service

If you're using Kubernetes version 1.18, Azure defaults to the correct Ubuntu
node base image. When
[creating your cluster](../../../setup/Kubernetes/azure.md), set
`--kubernetes-version` to `1.18.x` or newer for CVMs.

## Amazon Web Services w/ EKS

You can modify an existing [AWS-hosted container](../../setup/kubernetes/aws.md)
to support CVMs by
[creating a nodegroup](https://eksctl.io/usage/managing-nodegroups/#creating-a-nodegroup-from-a-config-file)
and updating your `eksctl` config spec.

1. Define your config file in the location of your choice (we've named the file
   `coder-node.yaml`, but you can call it whatever you'd like):

   ```yaml
   apiVersion: eksctl.io/v1alpha5
   kind: ClusterConfig

   metadata:
     version: "1.17"
     name: <YOUR_CLUSTER_NAME>
     region: <YOUR_AWS_REGION>

   nodeGroups:
     - name: coder-node-group
       amiFamily: Ubuntu2004
       ami: <your Ubuntu 20.04 AMI ID>
   ```

   > [See here for a list of EKS-compatible Ubuntu
   > AMIs](https://cloud-images.ubuntu.com/docs/aws/eks/)

1. Create your nodegroup (be sure to provide the correct file name):

   ```console
   eksctl create nodegroup --config-file=coder-node.yaml
   ```
