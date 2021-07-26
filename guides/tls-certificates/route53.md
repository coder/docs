---
title: Route 53
description:
  Learn how to use cert-manager to set up TLS certificates using Route 53 for
  DNS01 challenges.
---

[cert-manager](https://cert-manager.io/) allows you to enable HTTPS on your
Coder installation, regardless of whether you're using
[Let's Encrypt](https://letsencrypt.org/) or you have your own certificate
authority.

This guide will show you how to install cert-manager v1.4.0 and set up your
cluster to issue Let's Encrypt certificates for your Coder installation so that
you can enable HTTPS on your Coder deployment. It will also show you how to
configure your Coder hostname and dev URLs.

> We recommend reviewing the official cert-manager
> [documentation](https://cert-manager.io/docs/) if you encounter any issues or
> if you want info on using a different certificate issuer.

## Prerequisites

You must have:

- A Kubernetes cluster
  [of a supported version](../../setup/kubernetes/index.md#supported-kubernetes-versions)
  with internet connectivity
- Installed [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

You should also:

- Be a cluster admin
- Have access to your DNS provider.
- Have an AWS account so that you can access
  [Route 53](https://aws.amazon.com/route53/) and
  [IAM](https://aws.amazon.com/iam/)

## Step 1: Add cert-manager to your Kubernetes cluster

1. [Install](https://cert-manager.io/docs/installation/kubernetes/#installing-with-regular-manifests)
   cert-manager:

   ```console
   kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml
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

   NAME                                       READY   STATUS    RESTARTS   AGE
   cert-manager-7cd5cdf774-vb2pr              1/1     Running   0          84s
   cert-manager-cainjector-6546bf7765-ssxhf   1/1     Running   0          84s
   cert-manager-webhook-7f68b65458-zvzn9      1/1     Running   0          84s

   ```

## Step 2: Delegate your domain names and set up DNS01 challenges

Because Coder dynamically generates domains (specifically the dev URLs), your
certificates need to be approved and challenged. The following steps will show
you how to use Route 53 for DNS01 challenges.

If your domain name is managed by Route 53, the hosted zone will already exist
so skip to step 3.

1. Log in to AWS Route 53. On the Dashboard, click **Hosted Zone**.

1. Click **Create Hosted Zone**. In the configuration screen, provide the
   **Domain name** that you'll use for Coder (e.g., `coder.exampleCo.com`) and
   make sure that you've selected **Public hosted zone**. Click **Create hosted
   zone** to proceed.

   When your list of hosted zones refreshes, you'll see that your new records
   includes multiple values under **Value/Route traffic to**.

1. Log in to your DNS provider so that you can edit your NS records.

1. Edit your NS record to delegate your zones to AWS by sending _each_ of the
   values under **Value/Route traffic to** to your domain name (i.e., delegate
   `ns-X.awsdns-32.net` to `coder.exampleCo.com`).

## Step 3: Create an IAM role for `clusterIssuer`

To make sure that your `clusterIssuer` can change your DNS settings,
[create the required IAM role](https://cert-manager.io/docs/configuration/acme/dns01/route53/#set-up-an-iam-role)

When you create the secret for cert-manager, referenced below as
`route53-credentials` be sure it is in the cert-manager namespace since it's
used by the cert-manager pod to perform DNS configuration changes.

## Step 4: Create the ACME Issuer

1. Using the text editor of your choice, create a new
   [configuration file](https://cert-manager.io/docs/configuration/acme/dns01/)
   called `letsencrypt.yaml` (you can name it whatever you'd like) that includes
   your newly created IAM role:

   ```yaml
   apiVersion: cert-manager.io/v1
   kind: ClusterIssuer
   metadata:
     name: letsencrypt
   spec:
     acme:
       email: user@example.com
       preferredChain: ""
       privateKeySecretRef:
         name: example-issuer-account-key
       server: https://acme-v02.api.letsencrypt.org/directory
       solvers:
         - dns01:
             route53:
               accessKeyID: your-access-key-ID #secret with IAM Role
               region: your-region
               secretAccessKeySecretRef:
                 key: secret-access-key
                 name: route53-credentials
           selector:
             dnsZones:
               - yourDomain.com
   ```

   More information on the values in the YAML file above can be found in
   [the dns01 solver configuration documentation](https://cert-manager.io/docs/configuration/acme/dns01/).

1. Apply your configuration changes

   ```console
   kubectl apply -f letsencrypt.yaml
   ```

   If successful, you'll see a response similar to

   ```console
   clusterissuer.cert-manager.io/letsencrypt created
   ```

## Step 5: Install Coder

At this point, you're ready to [install](../../setup/installation.md) Coder.
However, to use all of the functionality you set up in this tutorial, use the
following `helm install` command instead:

```console
helm install coder coder/coder --namespace coder \
  --version=<CODER_VERSION> \
  --set devurls.host="*.coder.exampleCo.com" \
  --set ingress.host="coder.exampleCo.com" \
  --set ingress.tls.enable=true \
  --set ingress.tls.devurlsHostSecretName=coder-devurls-cert \
  --set ingress.tls.hostSecretName=coder-root-cert \
  --set ingress.annotations."cert-manager\.io/cluster-issuer"="letsencrypt" \
  --wait
```

The `hostSecretName` and `devurlsHostSecretName` are arbitrary strings that you
should set to some value that does not conflict with any other secrets in the
Coder namespace.

There are also a few additional steps to make sure that your hostname and dev
URLs work.

1. Check the contents of your namespace:

   ```console
   kubectl get all -n <your_namespace> -o wide
   ```

   Find the **service/coderd** line, and copy the **external IP** value shown.

1. Return to Route53 and go to **Hosted Zone**.

1. Create a new record for your hostname; provide `coder` as the record name and
   paste the external IP as the `value`. Save.

1. Create another record for your dev URLs: set it to `*.dev.exampleCo` or
   similar and use the same external IP as the previous step for `value`. Save.

At this point, you can return to **step 6** of the
[installation](../../setup/installation.md) guide to obtain the admin
credentials you need to log in. If you are not getting a valid certificate after
redeploying, see
[cert-manager's troubleshooting guide](https://cert-manager.io/docs/faq/acme/)
for additional assistance.
