---
title: Terraform
description: Learn how to deploy Coder using Terraform.
---

Coder offers [Terraform modules](https://github.com/coder/enterprise-terraform)
that help you deploy Coder faster.

Currently, we offer a single-command deployment of Coder to Google Cloud
Platform. We will add support for additional cloud providers in the future.

## Deploying Coder to Google Cloud Platform

> Before proceeding, please make sure that you have both
> [Terraform](https://www.terraform.io/downloads.html) and
> [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/quick-start/)
> installed.

1. [Copy the GKE example](https://github.com/coder/enterprise-terraform/tree/main/examples/gke/self-hosted)
   to the location of your choice (we recommend version controlling the entire
   folder).

1. [Create a cloud DNS zone](https://cloud.google.com/dns/docs/quickstart)
   containing your desired hostname. This must be in the same GCP project where
   you will deploy Coder.

1. Update the `terragrunt.hcl` file that's included in the root of your example
   folder. The `terragrunt.hcl` file contains notes that will guide you through
   customization options available. When done, you can view the changes you
   proposed running:

   ```console
   terragrunt run-all plan
   ```

   If you run the above command and it fails, you may have misconfigured one or
   more of the variables required. The output will direct you to the problematic
   areas.

1. Deploy Coder by running:

   ```console
   terragrunt run-all apply
   ```

   If the `apply` command succeeds, you will be able to access Coder at the
   hostname you provided. Log in with `admin` as the username and the password
   that you're provided.

## Tear down

To tear down your Coder deployment, run:

```console
terragrunt run-all destroy
```
