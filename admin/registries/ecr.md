---
title: "Amazon Elastic Container Registry"
description: Add a private Amazon ECR to Coder.
---

This article will show you how to add your private ECR to Coder. If you're using
a public ECR registry, you do not need to follow the steps below.

Amazon requires users to [request temporary login credentials to access a
private Elastic Container Registry (ECR)
registry](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html).
When interacting with ECR, Coder will request temporary credentials from the
registry using the AWS credentials linked to the registry.

## Step 1: Setting up your AWS credentials

To access a private ECR registry, Coder needs AWS credentials (specifically your
**access key ID** and **secret access key**) with authorization to access the
provided registry. You can either use AWS credentials tied to your own AWS
account *or* credentials tied to an IAM user specifically for Coder (we
recommend the latter option).

Note that you are not limited to providing one single set of AWS credentials.
For example, you can use a set of credentials with access to all of your ECR
repositories, or you can use individual sets of credentials, each with access to
a single repository.

To provision AWS credentials for Coder:

1. **Optional:** [Create an IAM user for
   Coder](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
   to access ECR. You can either attach the AWS-managed policy
   `AmazonEC2ContainerRegistryReadOnly` to the user, or you can [create your
   own](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policy-examples.html).

1. [Create an access
   key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
   for the IAM user to be used with Coder (if one does not already exist).

## Step 2: Add your private ECR registry to Coder

You can add your private ECR registry at the same time that you [add your
images](../../images/index.md). To import an image:

1. In Coder, go to **Images** and click on **Import Image** in the upper-right.

1. In the dialog that opens, you'll be prompted to pick a registry. However, to
   _add_ a registry, click **Add a new registry** located immediately below the
   registry selector.

1. Provide a **registry name** and the **registry**.

1. Set the **registry kind** to **ECR** and provide your **Access Key ID** and
   **Secret Access Key**.

1. Continue with the process of [adding your image](../../images/index.md).

1. When done, click **Import**.
