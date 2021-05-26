---
title: Azure DNS
description: Learn how to use cert-manager to set up SSL certificates using Azure
DNS for DNS01 challenges.
---

[cert-manager](https://cert-manager.io/) allows you to enable HTTPS on your
Coder installation, regardless of whether you're using
[Let's Encrypt](https://letsencrypt.org/) or you have your own certificate
authority.

This guide will show you how to install cert-manager v1.0.1 and set up your
cluster to issue Let's Encrypt certificates for your Coder installation so that
you can enable HTTPS on your Coder deployment. It will also show you how to
configure your Coder hostname and dev URLs.

There are three available methods to configuring the Azure DNS DNS01 Challenge via
cert-manager:

- [Managed Identity Using AAD Pod Identities](#step-1:-set-up-a-managed-identity)
- [Managed Identity Using AKS Kubelet Identity](https://cert-manager.io/docs/configuration/acme/dns01/azuredns/#managed-identity-using-aks-kubelet-identity)
- [Service Principal](https://cert-manager.io/docs/configuration/acme/dns01/azuredns/#service-principal)

This guide will only walk through the _first_ option. Yet the prerequisites will
remain the same across all three.

> We recommend reviewing the official cert-manager
> [documentation](https://cert-manager.io/docs/) if you encounter any issues or
> if you want info on using a different certificate issuer.

## Prerequisites

You must have:

- A Kubernetes cluster with internet connectivity
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

You should also:

- Be a cluster admin
- Have access to your DNS provider
- Have an Azure account and paid subscription so you can access [Azure DNS](https://azure.microsoft.com/en-us/services/dns/)

## Step 1: Create an Azure DNS Zone

In Azure, navigate to **All services** and select **DNS Zones**. From there,
click **New**, give it a name and select the **Resource Group** that your Coder
deployment lives in.

## Step 2: Assign Azure Nameservers to your domain

Navigate to your domain provider, and add the four Azure Nameserver records
(found on your DNS Zone) to the domain to be used for your Coder deployment.

## Step 3: Add cert-manager to your Kubernetes cluster

1. [Install](https://cert-manager.io/docs/installation/kubernetes/#installing-with-regular-manifests)
   cert-manager:

   ```console
   kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.2.0/cert-manager.yaml
   ```

1. Check that cert-manager installs correctly by running

   ```console
   kubectl get CustomResourceDefinition | grep cert-manager
   ```

   You should see certificates, certificate requests, challenges, cluster
   issuers, issuers, and orders.

1. Next, check that your services are running in the cert-manager namespace

   ```console
   kubectl get all -n cert-manager
   ```

## Step 4: Set up a Managed Identity

[AAD Pod Identities](https://azure.github.io/aad-pod-identity/) enables you to
assign an Active Directory Managed Identity to a pod. This allows for creating the
required DNS records without adding explicit credentials to the cluster.

1. Create the identity with access to the DNS Zone

    ```console
    # Choose a unique Identity name and existing resource group to create identity in.
    IDENTITY=$(az identity create --name $IDENTITY_NAME --resource-group $IDENTITY_GROUP )

    # Gets principalId to use for role assignment
    PRINCIPAL_ID=$(echo $IDENTITY | jq -r '.principalId')

    # Used for identity binding
    CLIENT_ID=$(echo $IDENTITY | jq -r '.clientId')
    RESOURCE_ID=$(echo $IDENTITY | jq -r '.id')

    # Get existing DNS Zone Id
    ZONE_ID=$(az network dns zone show --name $ZONE_NAME --resource-group $ZONE_GROUP --query "id" -o tsv)

    # Create role assignment
    az role assignment create --role "DNS Zone Contributor" --assignee $PRINCIPAL_ID --scope $ZONE_ID
    ```

## Step 5: Deploy the Managed Identity

1. Deploy AAD Pod Identity

    Export the following environment variables:

    ```console
    export SUBSCRIPTION_ID="05e8b285-4ce1-46a3-b4c9-f51ba67d6acc"
    export RESOURCE_GROUP="workshop-202103"
    export CLUSTER_NAME="coder-workshop-202103"
    ```

1. Deploy AAD Pod Identity components to an RBAC-enabled cluster

    ```console
    kubectl apply -f https://raw.githubusercontent.com/Azure/   aad-pod-identity/master/deploy/infra/deployment-rbac.yaml

    # For AKS clusters, deploy the MIC and AKS add-on exception by  running -
    kubectl apply -f https://raw.githubusercontent.com/Azure/   aad-pod-identity/master/deploy/infra/mic-exception.yaml
    ```

_Note: if using a non-RBAC cluster, remove the `-rbac` string from the first command._

1. Deploy AzureIdentity and AzureIdentityBinding

    Create an `azureId.yaml` file using the template below to deploy the
    custom resources required to assign the identity

    ```yaml
    apiVersion: "aadpodidentity.k8s.io/v1"
    kind: AzureIdentity
    metadata:
      annotations:
        # recommended to use namespaced identites https://azure.github.io/  aad-pod-identity/docs/configure/match_pods_in_namespace/
        aadpodidentity.k8s.io/Behavior: namespaced 
      name: certman-identity
      namespace: cert-manager # change to your preferred namespace
    spec:
      type: 0 # MSI
      resourceID: <Identity_Id> # Resource Id From Previous step
      clientID: <Client_Id> # Client Id from previous step
    ---
    apiVersion: "aadpodidentity.k8s.io/v1"
    kind: AzureIdentityBinding
    metadata:
      name: certman-id-binding
      namespace: cert-manager # change to your preferred namespace
    spec:
      azureIdentity: certman-identity
      selector: certman-label # This is the label that needs to be set on   cert-manager pods
    ```

1. Apply the azureId.yaml file

    ```console
    kubectl apply -f azureId.yaml
    ```

1. Set pod identity label on cert-manager pod

    ```yaml
    spec:
        template:
            metadata:
                labels:
                    aadpodidbinding: certman-label # must match selector in AzureIdentityBinding
    ```

## Step 6: Create the ACME Issuer

1. Create a file called `letsencrypt.yaml` (you can name it whatever you'd like)
to specify the `hostedZoneName`, `resourceGroupName` and `subscriptionID` fields
for the DNS Zone

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    email: user@example.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: example-issuer-account-key
    solvers:
    - selector:
        dnsZones:
        - # Your Azure DNS Zone
      dns01:
        azureDNS:
          subscriptionID: SUBSCRIPTION_ID
          resourceGroupName: RESOURCE_GROUP
          hostedZoneName: ZONE_ID
          # Azure Cloud Environment, default to AzurePublicCloud
          environment: AzurePublicCloud
```

1. Apply your configuration changes

   ```console
   kubectl apply -f letsencrypt.yaml
   ```

   If successful, you'll see a response similar to

   ```console
   clusterissuer.cert-manager.io/letsencrypt created
   ```

## Step 7: Install Coder

At this point, you're ready to [install](../../setup/installation.md) Coder.
However, to use all of the functionality you set up in this tutorial, use the
following `helm install` command instead:

```console
helm install coder coder/coder --namespace coder \
  --version=<CODER_VERSION> \
  --set devurls.host="*.exampleCo.com" \
  --set ingress.host="coder.exampleCo.com" \
  --set ingress.tls.enable=true \
  --set ingress.tls.devUrlsHostSecretName=devUrlCertificate \
  --set ingress.tls.hostSecretName=hostCertificate \
  --set ingress.annotations="cert-manager.io/cluster-issuer:letsencrypt" \
  --wait
```

There are also a few additional steps to make sure that your hostname and dev
URLs work.

1. Check the contents of your namespace:

   ```console
   kubectl get all -n <your_namespace> -o wide
   ```

   Find the **service/ingress-nginx** line and copy its **external IP** value.

1. Return to Azure and go to **DNS zones**.

1. Create a new record for your hostname; provide `coder` as the record name and
   paste the external IP as the `value`. Save.

1. Create another record for your dev URLs: set it to `*.dev.exampleCo` or
   similar and use the same external IP as the previous step for `value`. Save.

At this point, you can return to **step 6** of the
[installation](../../setup/installation.md) guide to obtain the admin
credentials you need to log in.

## Troubleshooting

If you are not getting a valid certificate after
redeploying, see [cert-manager's troubleshooting
guide](https://cert-manager.io/docs/faq/acme/) for additional assistance.
