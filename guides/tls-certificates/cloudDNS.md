---
title: Google Cloud DNS
description:
  Learn how to use cert-manager to set up TLS certificates using Google Cloud
  DNS for DNS01 challenges.
---

[cert-manager](https://cert-manager.io/) allows you to enable HTTPS on your
Coder installation, regardless of whether you're using
[Let's Encrypt](https://letsencrypt.org/) or you have your own certificate
authority.

> This guide is for Coder v1.21.0 and later, which handle certificates
> differently from earlier versions of Coder. Ensure that you're reading the
> docs applicable to your Coder version.

This guide will show you how to install cert-manager v1.4.0 and set up your
cluster to issue Let's Encrypt certificates for your Coder installation so that
you can enable HTTPS on your Coder deployment. It will also show you how to
configure your Coder hostname and dev URLs.

> We recommend reviewing the official cert-manager
> [documentation](https://cert-manager.io/docs/) if you encounter any issues or
> if you want info on using a different certificate issuer.

You must have:

- A Kubernetes cluster
  [of a supported version](../../setup/kubernetes/index.md#supported-kubernetes-versions)
  with internet connectivity
- Installed [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- A [Cloud DNS](https://cloud.google.com/dns) account
- A
  [GCP Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
  with the `dns.admin` role

## Step 1: Add cert-manager to your Kubernetes cluster

To add cert-manager to your cluster, run:

```console
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml
```

More specifics can be found in the
[cert-manager install documentation](https://cert-manager.io/docs/installation/kubernetes/#installing-with-regular-manifests).

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
   apiVersion: cert-manager.io/v1
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

   More information on the values in the YAML file above can be found in
   [the dns01 solver configuration documentation](https://cert-manager.io/docs/configuration/acme/dns01/).

1. Apply your configuration changes:

   ```console
   kubectl apply -f letsencrypt.yaml
   ```

   If successful, you'll see a response similar to:

   ```console
   clusterissuer.cert-manager.io/letsencrypt created
   ```

## Step 5: Create a certificate

> Note: If you are providing an ingress, certificates can be automatically
> created with an ingress annotation. See the
> [cert-manager docs](https://cert-manager.io/docs/usage/ingress/) for details.
> If you are unsure whether you are using an ingress or not, continue with this
> step.

In a text editor, create a new file called **certificate.yaml** and paste the
following:

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: coder-certs
  namespace: coder # Your Coder deployment namespace
spec:
  commonName: "*.coder.example.com"
  dnsNames:
    - "coder.example.com"
    - "*.coder.example.com"
  issuerRef:
    kind: ClusterIssuer
    name: letsencrypt
  secretName: coder-certs
```

Be sure to change `coder.example.com` to the domain for your Coder deployment.
While this example uses a single domain, a separate domain can be created for
dev URLs or even omitted if you do not have
[dev URLs enabled](../admin/devurls).

Once you're done, deploy the certificates.

```console
kubectl apply -f certificate.yaml
```

## Step 6: Install/upgrade Coder

At this point, you're ready to [install](../../setup/installation.md) Coder.
However, to use all of the functionality you set up in this tutorial, use the
following command instead:

```console
helm upgrade --install coder coder/coder --namespace coder \
  --version=<CODER_VERSION> \
  --set coderd.devurlsHost="coder.example.com" \
  --set coderd.tls.devurlsHostSecretName="coder-certs" \
  --set coderd.tls.hostSecretName="coder-certs" \
  --wait
```

The cluster-issuer will create the certificates you need, using the values
provided in the `helm install` command for the dev URL and host secret.

There are additional steps to make sure that your hostname and Dev URLs work.

## Step 6: Configure DNS resolution

1. Check the contents of your namespace

   ```console
   kubectl get svc -n <your_namespace> -o wide
   ```

   Find the **service/coderd** line, and copy the **external IP** value shown.

1. Return to Google Cloud Platform, navigate to the
   [Cloud DNS](https://cloud.google.com/dns) Console, and select the Zone that
   your cluster is in.

   **Note:** You will need to create two A records, one for both the hostname
   and Dev URLs

1. Click **Add Record Set**

1. Provide your **DNS Name**

   a. If you're configuring the hostname, this value will be a standard domain

   b. If you're configuring your dev URLs, this will be a wildcard domain (e.g.,
   `*.example.com`)

1. Set the **Resource Record Type** to **A**

1. Copy and paste the external IP address associate with the **service/coderd**
   line from your terminal to the `IPv4 Address` field.

1. Click **Create**

At this point, you can return to **step 6** of the
[installation](../../setup/installation.md) guide to obtain the admin
credentials you need to log in.

## Troubleshooting

If you are not getting a valid certificate after redeploying, see
[cert-manager's troubleshooting guide](https://cert-manager.io/docs/faq/acme/)
for additional assistance.
