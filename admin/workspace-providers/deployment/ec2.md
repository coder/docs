---
title: EC2
description: Learn how to deploy a workspace provider to an EC2 cluster.
state: alpha
---

This article walks you through the process of deploying a workspace provider to
an EC2 instance.

The use of EC2 providers is currently an **alpha** feature. Before using, please
enable this feature under **Feature Preview**:

1. Log into Coder as a site manager or site admin.
1. In the top-right, click on your avatar and select **Feature Preview**.
1. Select **Amazon EC2 (Docker) providers** and click **Enable**.

## Prerequisites

You must have an
[**AWS access key ID** and **secret access key**](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys).

We recommend having the [AWS CLI](https://aws.amazon.com/cli/) installed and
configured as well.

### IAM permissions

To manage EC2 providers for your Coder deployment, create an IAM policy and
attach it to the IAM identity (e.g., role) that will be managing your resources
(be sure to update or remove `aws:RequestedRegion` accordingly):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "ec2:*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": "us-east-1"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeSubnets",
        "ec2:CreateSecurityGroup",
        "ec2:DescribeSecurityGroups",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:DeleteSecurityGroup",
        "ec2:ImportKeyPair",
        "ec2:DescribeKeyPairs",
        "ec2:CreateVolume",
        "ec2:DescribeVolumes",
        "ec2:AttachVolume",
        "ec2:DeleteVolume",
        "ec2:RunInstances",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:TerminateInstances",
        "ec2:DescribeInstanceTypes",
        "ec2:CreateTags"
      ],
      "Resource": "*"
    }
  ]
}
```

## 1. Select the workspace provider type to create

1. Log into Coder as a site manager, and go to **Manage** > **Workspace
   providers**.

1. In the top-right next to **Create Kubernetes Provider**, click on the **down
   arrow** and select **Create Amazon EC2 Provider**.

1. Provide a **name** to identify the provider.

## 2. Configure the connection to AWS

Provide the requested configuration details to connect Coder to your AWS
account:

- **Access key ID**: the AWS access key associated with your account
- **Secret access key**: the AWS secret access key associated with your account
- **AWS region ID**: select the AWS region where the EC2 instances should be
  created
- **AWS availability zone**: the AWS availability zone associated with the
  region where the EC2 instances are created

## 3. Provide networking information (optional)

Provide the following networking options if desired:

- VPC ID: Optional. The VPC network to which instances should be attached. If
  you leave this field empty, Coder uses the default VPC ID in the specified
  region for your EC2 instances
- Subnet ID: Optional. The
  [ID of the subnet](https://docs.aws.amazon.com/managedservices/latest/userguide/find-subnet.html)
  associated with your VPC and availability zone. If you leave this field empty,
  Coder uses the default subnet associated with the VPC in your region and
  availability zone.

## 4. Provide AMI configuration information

Specify the Amazon Machine Image configuration you want to be used when
launching workspaces:

- **Privileged mode**: Optional. check this box if you would like the workspace
  container to have read/write access to the EC2 instance's host filesystem

> Privileged mode may pose a security risk to your organization. We recommend
> enabling this feature only if users need full access to the host (e.g., kernel
> driver development or running Docker-in-Docker).

- **AMI ID**: the Amazon machine image ID to be used when creating the EC2
  instances; the machine image used must contain and start a Docker daemon. If
  blank, Coder defaults to an image that meets the requirements. If you selected
  a supported AWS region, this will auto-populate with a supported AMI (though
  you are welcome to change it)
- **Instance types**: Optional. The EC2 instance types that users can provision
  using the workspace provider. Provide each instance type on a separate line;
  wildcard characters are allowed
- **AMI SSH username**: the SSH login username used by Coder to connect to EC2
  instances. Must be set if you provide a custom AMI ID (this value may be
  auto-populated depending on the AMI you choose))
- **Root volume size**: the storage capacity to be reserved for the copy of the
  AMI
- **Docker volume size**: the storage capacity used for the Docker daemon
  directory; stores the workspace image and any ephemeral data outside of the
  home directory

## 5. Enable external connections (optional)

Toggle **external connect** on if you would like to enable SSH connections to
your workspaces via the Coder CLI.

## 6. Create the provider

Click **Create provider** to proceed.
