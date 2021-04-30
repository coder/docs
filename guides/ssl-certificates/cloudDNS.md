---
title: Cloud DNS
description:
  Learn how to use cert-manager to set up SSL certificates using Cloud DNS for
  DNS01 challenges.
---

[cert-manager](https://cert-manager.io/) allows you to enable HTTPS on your
Coder installation, regardless of whether you're using
[Let's Encrypt](https://letsencrypt.org/) or you have your own certificate
authority.

This guide will show you how to install cert-manager v1.0.1 and set up your
cluster to issue Let's Encrypt certificates for your Coder installation so that
you can enable HTTPS on your Coder deployment. It will also show you how to
configure your Coder hostname and dev URLs.

> We recommend reviewing the official cert-manager
> [documentation](https://cert-manager.io/docs/) if you encounter any issues or
> if you want info on using a different certificate issuer.

You must have:

- A Kubernetes cluster with internet connectivity
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- A [Cloud DNS](https://cloud.google.com/dns) account
- A
  [GCP Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
  with the `dns.admin` role

## Step 1: Add cert-manager to your Kubernetes cluster

To add cert-manager to your cluster (which we assume to be running Kubernetes
1.16+), run:

```console
kubectl apply --validate=false -f \
https://github.com/jetstack/cert-manager/releases/download/v1.0.1/cert-manager.yaml
```

> `--validate=false` is required to bypass kubectl's resource validation on the
> client-side that exists in older versions of Kubernetes.

Once you've started the installation process, verify that all the pods are
running:

```console
$ kubectl get pods -n cert-manager

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-7cd5cdf774-vb2pr              1/1     Running   0          84s
cert-manager-cainjector-6546bf7765-ssxhf   1/1     Running   0          84s
cert-manager-webhook-7f68b65458-zvzn9      1/1     Running   0          84s
```

## Step 2: Get the private key from the service account

You can get the private key from the GCP Service Account using:

```console
gcloud iam service-accounts keys create key.json \
--iam-account <service-account-name>@<project-name>.iam.gserviceaccount.com
```

The response should look similar to the following:

```console
created key [44...3d] of type [json] as [key.json] for [<service-account-name>@<project-name>.iam.gserviceaccount.com]
```

## Step 3: Configure cluster issuer secret and add it to cert-manager namespace

Next, configure the cluster issuer secret, and add it to cert-manager's
namespace:

```console
kubectl -n cert-manager create secret generic \
clouddns-dns01-solver-svc-acct --from-file=./key.json
```

If successful, you'll see a response similar to:

```console
secret/clouddns-dns01-solver-svc-acct created
```

## Step 4: Create a cluster issuer resource and apply it

1. Using the text editor of your choice, create a new
   [configuration file](https://cert-manager.io/docs/configuration/acme/dns01/)
   called `letsencrypt.yaml` (you can name it whatever you'd like) that includes
   your newly created private key:

```yaml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    privateKeySecretRef:
      name: gclouddnsissuersecret
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - dns01:
          clouddns:
            # The ID of the GCP project
            project: <project-id>
            # This is the secret used to access the service account
            serviceAccountSecretRef:
              name: clouddns-dns01-solver-svc-acct
              key: key.json
```

1. Apply your configuration changes:

```console
kubectl apply -f ./clusterissuer.yaml
```

If successful, you'll see a response similar to:

```console
clusterissuer.cert-manager.io/letsencrypt created
```

## Step 5: Create a certificates.yaml file and apply it

We will now issue certificates for your Coder instance. Below is a sample
`certificates.yaml` file:

```yaml
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: coder-root
  namespace: # Your Coder deployment namespace
spec:
  secretName: # Your Coder base url secret name. Use hyphens in place of spaces.
  duration: 2160h # 90d
  renewBefore: 360h # 15d
  dnsNames:
    - domain.com # Your base domain for Coder
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer

---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: coder-devurls
  namespace: # Your Coder deployment namespace
spec:
  secretName: coder-devurls-cert # Your Coder devurls secret name
  duration: 2160h # 90d
  renewBefore: 360h # 15d
  dnsNames:
    - "*.domain.com" # Your dev URLs wildcard subdomain
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer
```

At this point, you're ready to [install](../../setup/installation.md) Coder.
However, to use all of the functionality you set up in this tutorial, use the
following `helm install` command instead:

```console
helm install coder coder/coder --namespace coder \
  --version=<CODER_VERSION> \
  --set devurls.host="*.exampleCo.com" \
  --set ingress.host="coder.exampleCo.com" \
  --set ingress.tls.enable=true \
  --set ingress.tls.devUrlsHostSecretName="coder-devurls-cert" \
  --set ingress.tls.hostSecretName="coder-root-cert" \
  --set \
  "ingress.additionalAnnotations[0]=cert-manager.io/cluster-issuer:letsencrypt" \
  --wait
```

There are additional steps to make sure that your hostname and Dev URLs work.

1. Check the contents of your namespace

   ```console
   kubectl get all -n <your_namespace> -o wide
   ```

   Find the **service/ingress-nginx** line and copy the **external IP** value
   shown.

1. Return to Google Cloud Platform, navigate to the
   [Cloud DNS](https://cloud.google.com/dns) Console, and select the Zone that
   your cluster is in.

   **Note:** You will need to create two A records, one for both the hostname
   and Dev URLs

1. Click **Add Record Set**

1. Provide your **DNS Name**

   a. If you're configuring the hostname, this value will be a standard domain

   b. If you're configuring your dev URLs, this will be a wildcard domain (e.g.,
   `*.domain.com`)

1. Set the **Resource Record Type** to **A**

1. Copy and paste the IP address from the **service/ingress-nginx** line in your
   terminal to the `IPv4 Address` field

1. Click **Create**

At this point, you can return to **step 6** of the
[installation](../../setup/installation.md) guide to obtain the admin
credentials you need to log in.

---

If you are not getting a valid certificate after redeploying, see
[this troubleshooting guide](https://cert-manager.io/docs/faq/acme/) by
cert-manager.
