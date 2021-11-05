---
title: EC2
description: Learn how to deploy a workspace provider to an EC2 cluster.
---

This article walks you through the process of deploying a workspace provider to
an EC2 instance.

## Prerequisites

You must have an
[**AWS access key ID** and **secret access key**](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys).

We recommend having the [AWS CLI](https://aws.amazon.com/cli/) installed and
configured as well.

## Creating a workspace provider

1. Log into Coder as a site manager, and go to **Manage** > **Workspace
   providers**.

1. In the top-right next to **Create Kubernetes Provider**, click on the **down
   arrow** and select **Create Amazon EC2 Provider**.

1. Provide a **name** to identify the provider.

1. Provide the requested configuration details to connect Coder to your AWS
   account:

   - **Access key ID**: the AWS access key associated with your account
   - **Secret access key**: the AWS secret access key associated with your
     account
   - **AWS region ID**: The AWS region where the EC2 instances should be created
   - **AWS availability zone**: The AWS availability zone associated with the
     region where the EC2 instances are created. You can find an available zone
     by running `aws ec2 describe-availability-zones --region region-name`

1. Provide the networking options:

   - VPC ID: the VPC network to which instances should be attached. If you leave
     this field empty, Coder uses the default VPC ID in the specified region for
     your EC2 instances
   - Subnet ID: the
     [ID of the subnet](https://docs.aws.amazon.com/managedservices/latest/userguide/find-subnet.html)
     associated with your VPC and availability zone

1. Specify the Amazon Machine Image configuration you want to be used when
   launching workspaces:

   - **Privileged mode**: check this box if you would like the workspace
     container to have read/write access to the EC2 instance's host filesystem
   - **AMI ID**: the Amazon machine image ID to be used when creating the EC2
     instances; the machine image used must contain and start a Docker daemon.
     If blank, Coder defaults to an image that meets the requirements
   - **Instance types**: the EC2 instance types that users can provision using
     the workspace provider. Provide each instance type on a separate line;
     wildcard characters are allowed
   - **AMI SSH username**: the SSH login username used by Coder to connect to
     EC2 instances. Must be set if you provide a custom AMI ID
   - **Root volume size**: the storage capacity to be reserved for the copy of
     the AMI
   - **Docker volume size**: the storage capacity used for the Docker daemon
     directory; stores the workspace image and any data outside of the home
     directory

1. Toggle **external connect** on if you would like to enable SSH connections to
   your workspaces via the Coder CLI.

Click **Create provider** to proceed.
