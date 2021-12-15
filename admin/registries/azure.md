---
title: "Azure Container Registry"
description: Add a Microsoft Azure Container Registry (ACR) to Coder.
---

This article will show you how to add a private Azure Container Registry (ACR)
instance to Coder.

## Step 1: Set up authentication for Coder

Coder supports the
[following methods](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication)
for authenticating with ACR:

- Static credentials that the `docker login` command can consume
- **Alpha:** Azure Active Directory (AAD) Pod Identity

### Option A: Provision static credentials for Coder

ACR provides several options for using static credentials, including:

- Registry Administrator Account (not enabled by default)
- AAD Service Principal (SP)
- Individual AAD Identity
- Repository-scoped Access Token

Depending on your ACR SKU, some of the above features may not be available to
you. Additionally, depending on the method you use, you may need to regenerate
the static credentials used by Coder from time to time.

Please consult the
[Azure Container Registry Documentation](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication)
for more details.

Once you've chosen the option for using static credentials, make a note of your
username and password and proceed to **step 2** of this guide.

### Option B: Use an Azure Active Directory (AAD) Pod Identity

> This is currently an **alpha** feature. To use this feature, enable the
> feature flag under
> `Manage > Admin > Infrastructure > Azure Registry Authentication`.

AAD Pod Identity allows you to assign an AAD identity to pods in your Azure
Kubernetes (AKS) cluster. You can assign Coder an AAD identity with pull access
to an ACR instance so that Coder can access the registry without needing to
provide static credentials.

1. [Create your Azure role assignments and install AAD Pod Identity on your clusters.](https://azure.github.io/aad-pod-identity/docs/getting-started/)

   Consult the
   [AAD Pod Identity Documentation](https://azure.github.io/aad-pod-identity/docs/)
   for additional support on configuring this feature.

1. Once you have configured an Azure Identity Binding, ensure that you label the
   `coderd` deployment pods with the correct `aadpodidbinding` label.

   For example, if you name the Azure Identity `coder-identity`, then the pods
   in your `coderd` deployment should all have the label
   `aadpodidbinding: coder-identity`.

1. Verify that the Azure Identity binding is set up correctly. First, run:

   ```console
   kubectl run -it --rm --image=mcr.microsoft.com/azure-cli:latest --labels=aadpodidbinding=coder-identity aadpodidtest -- bash
   ```

   Then, run the following command, replacing the variables `$SUBSCRIPTION_ID`,
   `$RESOURCE_GROUP`, and `$IDENTITY_NAME` where appropriate:

   ```console
   bash-5.1# az login --identity -u /subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$IDENTITY_NAME

   # Expected output:
   [
   {
      "environmentName": "AzureCloud",
      "homeTenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "isDefault": true,
      "managedByTenants": [],
      "name": "Microsoft Azure Sponsorship",
      "state": "Enabled",
      "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "user": {
         "assignedIdentityInfo": "MSIResource-/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$IDENTITY_NAME",
         "name": "userAssignedIdentity",
         "type": "servicePrincipal"
      }
   }
   ]
   ```

   If you see output similar to the above, then you have successfully configured
   AAD Pod Identity!

#### Troubleshooting

You can manually check that Coder is able to acquire a token from the Azure
Instance Metadata Service (IMDS) by running the following (be sure to replace
the variable `$CLIENTID` with the ID of the user-assigned entity you are using):

```shell
kubectl -n coder exec -it deployment/coderd -- curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&client_id=$CLIENTID&resource=https%3A%2F%2Fmanagement.azure.com' -H 'Metadata:true'
```

If you receive an error similar to the following, try restarting `coderd` by
running the command `kubectl rollout restart deployment coderd`: the `coderd`
pod:

```shell
{"error":"invalid_request","error_description":"Identity not found"}
```

If you run into further issues, please check the
[official troubleshooting documentation for AAD Pod Identity](https://azure.github.io/aad-pod-identity/docs/troubleshooting/).

1. Next, set the `aadpodidbinding` label in your
   [Helm `values.yaml`](../../guides/admin/helm-charts.md):

   ```yaml
   extraLabels:
   aadpodidbinding: coder-identity
   ```

1. You will then need to upgrade the Helm deployment:

   ```shell
   helm upgrade coder coder/coder --values values.yaml
   ```

1. Finally, enable the feature flag under
   `Manage > Admin > Infrastructure > Azure Registry Authentication` if you
   haven't already.

## Step 2: Add your Azure Container Registry to Coder

You can add your private ACR instance at the same time that you
[add your images](../../images/index.md). To import an image:

1. In Coder, go to **Images** and click on **Import Image** in the upper-right.

1. In the dialog that opens, you'll be prompted to pick a registry. However, to
   _add_ a registry, click **Add a new registry** located immediately below the
   registry selector.

1. Provide a **registry name** and the **registry**.

1. Depending on how you are authenticating:

   1. If you are using **Static Credentials**, then set the **registry kind** to
      **Generic Registry** and provide the **username** and **password** as
      normal.

   1. If you are using AAD Pod Identity, set **Registry Kind** to **Microsoft
      Azure Container Registry**. You do not have to provide a username or
      password if you are using AAD Pod Identity.

1. Continue with the process of [adding your image](../../images/index.md).

1. When done, click **Import**.
