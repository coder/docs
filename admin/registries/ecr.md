---
title: "Private Amazon Elastic Container Registry (ECR)"
description: Add a private Amazon Elastic Container Registry (ECR) to Coder.
---

Amazon Elastic Container Registry (ECR)
[requires users to request temporary login credentials to access a private ECR registry](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html).
When interacting with AWS ECR, Coder will request temporary credentials from the
registry using the AWS credentials linked to the registry. This article will
show you how to add your existing private ECR to Coder. If you wish to use a
public ECR registry, you do not need to follow the below steps.

## Adding a private ECR registry

In order to access a private ECR registry, Coder needs AWS credentials (Access
Key ID and Secret Access Key) with authorization to access the provided
registry. You can either use AWS credentials tied to your own AWS account, or
credentials tied to an IAM user specifically for Coder (recommended).

Note that you are not limited to providing one single set of AWS credentials.
You can use one single set of credentials with access to all of your ECR
repositories, or use individual sets of credentials with access to single
repositories.

To provision AWS credentials for Coder:

1. (Optional) Follow the
   [steps](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
   to create an IAM user for Coder to access ECR. Either attach the AWS-managed
   policy `AmazonEC2ContainerRegistryReadOnly` to the user, or
   [create your own](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policy-examples.html).
1. [Create an access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
   for the IAM user to be used with Coder, if one does not already exist.

Add your private ECR registry during the process of
[adding images](../../images/index.md). To import an image:

1. Go to **Images** > **Import Image** in the upper-right.
1. In the dialog that opens, you'll be prompted to pick a registry by default.
   However, to _add_ a registry, click **Add a new registry**, which is the
   option located immediately below the registry selector.
1. You'll be asked to provide a **registry name** and the **registry**.
1. Since your registry is an **ECR Registry**, set the **registry kind** to
   `ECR` and enter the Access Key ID and Secret Access Key in their respective
   fields.
1. Continue with the process of [adding your image](../../images/index.md).
1. When done, click **Import**.
