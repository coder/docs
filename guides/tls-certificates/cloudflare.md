---
title: Cloudflare
description:
  Learn how to use cert-manager to set up TLS certificates using Cloudflare for
  DNS01 challenges.
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
you can enable HTTPS on your Coder deployment.

> We recommend reviewing the official cert-manager
> [documentation](https://cert-manager.io/docs/) if you encounter any issues or
> if you want info on using a different certificate issuer.

## Prerequisites

You must have:

- A Kubernetes cluster
  [of a supported version](../../setup/kubernetes/index.md#supported-kubernetes-versions)
  with internet connectivity
- Installed [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Step 1: Add cert-manager to your Kubernetes cluster

```console
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml
```

More specifics can be found in the
[cert-manager install documentation](https://cert-manager.io/docs/installation/kubernetes/#installing-with-regular-manifests).

Once you've started the installation process, you can verify that all the pods
are running:

```console
$ kubectl get pods -n cert-manager

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-7cd5cdf774-vb2pr              1/1     Running   0          84s
cert-manager-cainjector-6546bf7765-ssxhf   1/1     Running   0          84s
cert-manager-webhook-7f68b65458-zvzn9      1/1     Running   0          84s
```

## Step 2: Create an ACME issuer

cert-manager supports HTTP01 and DNS01 challenges, as well as
[many DNS providers](https://cert-manager.io/docs/configuration/acme/dns01/#supported-dns01-providers).
This guide, however, shows you how to use Cloudflare for DNS01 challenges. This
is necessary to issue wildcard certificates, which are required for Coder's
[dev URLs](../../admin/devurls.md) feature.

First, get the Cloudflare API credentials for cert-manager to use; cert-manager
needs permission to add a temporary TXT record and delete it after the challenge
has been completed.

Open the Cloudflare dashboard and go to
[My Profile > API Tokens](https://dash.cloudflare.com/profile/api-tokens). Click
**Create Token**, then go to **Create Custom Token** and click **Get Started**.

Create a token with the following settings:

- Permissions:

  - Zone: DNS = Edit
  - Zone: Zone = Read

- Zone Resources:
  - Include: Specific Zone = your-domain.com

You can also add more zones (or give the token access to all zones in your
account), and set an expiry date.

![Create Custom Token](../../assets/guides/tls-certificates/cloudflare-1.png)

Click **Continue to summary**, then **Create Token**. Be sure to copy and save
the token displayed because Cloudflare will not display it again.

Now that we have our Cloudflare API token, we need to configure cert-manager to
use it. In a text editor, create a new file called **issuer.yaml** and paste the
following:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token-secret
  namespace: coder # Your Coder deployment namespace
type: Opaque
stringData:
  api-token: "" # Your Cloudflare API token (from earlier)

---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt
  namespace: coder # Your Coder deployment namespace
spec:
  acme:
    email: "" # Your email address (given to Let's Encrypt)
    server: "https://acme-v02.api.letsencrypt.org/directory"
    privateKeySecretRef:
      name: letsencrypt-account-key
    solvers:
      - dns01:
          cloudflare:
            email: "" # Your Cloudflare email address
            apiTokenSecretRef:
              name: cloudflare-api-token-secret
              key: api-token

        # This section denotes which domains to use this issuer for. If you didn't
        # limit which zones the API token had access to, you may wish to remove
        # this section.
        selector:
          dnsZones:
            # Only use this issuer for the domain example.com and its subdomains.
            - "example.com"
```

More information on the values in the YAML file above can be found in
[the dns01 solver configuration documentation](https://cert-manager.io/docs/configuration/acme/dns01/).

### ClusterIssuers

cert-manager has a concept of **Issuer** (which are per-namespace) or
**ClusterIssuer** (which are global to the entire cluster). If you plan on using
cert-manager only for Coder, you may choose to use the **Issuer** configuration
above. If you want to use a **ClusterIssuer** instead, you'll need to make the
following changes:

- Change the namespace of the secret (and certificate object created in the next
  step) to **cert-manager**
- Change the kind of the **Issuer** to **ClusterIssuer**
- Remove the namespace of the **ClusterIssuer**
- Change the annotations to `cert-manager.io/cluster-issuer: "letsencrypt"`

For further information, see
[Setting Up Issuers](https://docs.cert-manager.io/en/release-0.8/tasks/issuers/index.html).

Read the comments and fill out the blanks. Once you're done, you can go ahead
and apply that to your cluster using:

```console
$ kubectl apply -f issuer.yaml

secret/cloudflare-api-key-secret created
issuer.cert-manager.io/letsencrypt created
```

## Step 3: Create a certificate

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
    kind: Issuer
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

## Step 4: Configure Coder to issue and use the certificates

If you're using the default LoadBalancer to access Coder, you can use the
following helm values to use the certificate.

```yaml
coderd:
  devurlsHost: "*.coder.example.com"
  tls:
    devurlsHostSecretName: "coder-certs"
    hostSecretName: "coder-certs"
```

Be sure to change `coder.example.com` to the domain for your Coder deployment.
The `hostSecretName` and `devurlsHostSecretName` correspond to the secret
specified by the certificate(s) created in step 2. The secret name(s) are
arbitrary, but ensure they do not conflict with any other secrets in the Coder
namespace.

Be sure to [redeploy Coder](../../setup/upgrade/index.md) after changing your
Helm values. Then, log in to Coder and change your access URL in
`Manage > Admin` to use HTTPS.

## Troubleshooting

If, after redeploying, you're not getting a valid certificate, see
[cert-manager's troubleshooting guide](https://cert-manager.io/docs/faq/acme/)
for additional assistance.
