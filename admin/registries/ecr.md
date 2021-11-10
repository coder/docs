---
title: "Amazon Elastic Container Registry"
description: Add a private Amazon ECR to Coder.
---

This article will show you how to add your private ECR to Coder. If you're using
a public ECR registry, you do not need to follow the steps below.

Amazon requires users to
[request temporary login credentials to access a private Elastic Container Registry (ECR) registry](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html).
When interacting with ECR, Coder will request temporary credentials from the
registry using the AWS credentials linked to the registry.

## Step 1: Setting up authentication for Coder

To access a private ECR registry, Coder needs to authenticate with AWS. Coder
supports two methods of authentication with AWS ECR:

- Static credentials
- IAM roles for service accounts

### Option A: Provision static credentials for Coder

You can use an **Access Key ID** and **Secret Access Key** tied to either your
own AWS account _or_ credentials tied to a dedicated IAM user (we recommend the
latter option).

> You are not limited to providing a single set of AWS credentials. For example,
> you can use a set of credentials with access to all of your ECR repositories,
> or you can use individual sets of credentials, each with access to a single
> repository.

To provision static credentials for Coder:

1. **Optional:**
   [Create an IAM user for Coder](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
   to access ECR. You can either attach the AWS-managed policy
   `AmazonEC2ContainerRegistryReadOnly` to the user, or you can
   [create your own](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policy-examples.html).

1. [Create an access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
   for the IAM user to be used with Coder (if one does not already exist).

### Option B: Link an AWS IAM role to the Coder Kubernetes service account (IRSA)

Coder can use an
[IAM role linked to Coder's Kubernetes service account](https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/),
though this is only supported when Coder is running in AWS EKS. This is because
the
[EKS Pod Identity Webhook](https://github.com/aws/amazon-eks-pod-identity-webhook/)
is required to provision and inject the required token into the `coderd` pod.

> For more information on IAM Roles for Service Accounts (IRSA), please consult
> the
> [AWS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).

To link an IAM role to Coder's Kubernetes service account:

1. Create an IAM OIDC Provider for your EKS cluster (if it does not already
   exist).

1. [Create the IAM role to be used by Coder (if it does not already exist).](https://docs.aws.amazon.com/eks/latest/userguide/create-service-account-iam-policy-and-role.html#create-service-account-iam-role).
   Ensure that you also create and attach a trust policy that permits the action
   `sts:AssumeRoleWithWebIdentity` for the Coder service account. The trust
   policy will look similar to the following:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "Federated": "arn:aws:iam::${ACCT_ID}:oidc-provider/${OIDC_PROVIDER}"
         },
         "Action": "sts:AssumeRoleWithWebIdentity",
         "Condition": {
           "StringEquals": {
             "${OIDC_PROVIDER}:sub": "system:serviceaccount:${NAMESPACE}:${SERVICE_ACCOUNT}"
           }
         }
       }
     ]
   }
   ```

1. Annotate the Coder service account with the role ARN:

   1. Add the following to your Helm `values.yaml`, replacing the variables
      `ACCT_ID` and `ROLE_NAME` where appropriate:

      ```yaml
      coderd:
       ...
       builtinProviderServiceAccount:
         ...
         annotations:
           eks.amazonaws.com/role-arn: my-role-arn
      ```

   1. Update the Helm deployment:

   ```shell
   helm upgrade coder coder/coder --values values.yaml
   ```

   1. Verify that the Coder service account now has the correct annotation:

   ```shell
   kubectl get serviceaccount coder -o yaml | grep eks.amazonaws.com/role-arn
     eks.amazonaws.com/role-arn: my-role-arn
   ```

1. Validate that pods created with the `coder` service account have permission
   to assume the role:

```shell
kubectl run -it --rm awscli --image=amazon/aws-cli \
  --overrides='{"spec":{"serviceAccount":"coder"}}' \
  --command aws ecr describe-repositories
```

## Step 2: Add your private ECR registry to Coder

You can add your private ECR registry at the same time that you
[add your images](../../images/index.md). To import an image:

1. In Coder, go to **Images** and click on **Import Image** in the upper-right.

1. In the dialog that opens, you'll be prompted to pick a registry. However, to
   _add_ a registry, click **Add a new registry** located immediately below the
   registry selector.

1. Provide a **registry name** and the **registry**.

1. Set the **registry kind** to **ECR** and provide your **Access Key ID** and
   **Secret Access Key**, if required. If you want to use IRSA instead of static
   credentials, to authenticate with ECR, leave **Access Key ID** and **Secret
   Access Key** blank.

1. Continue with the process of [adding your image](../../images/index.md).

1. When done, click **Import**.
