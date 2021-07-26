---
title: Access URL
description: Learn how to set the access URL.
---

This article will show you how to change your **access URL**, which is a custom
domain name that you can use to access your Coder deployment.

## Step 1: Ensure that your domain name resolves to Coder

The steps to do this vary based on the DNS provider you're using, but the
general steps required are as follows:

1. Check the contents of your namespace to obtain your ingress controller's IP
   address:

```console
kubectl get all -n <your_namespace> -o wide
```

Find the **service/ingress-nginx** line and copy the **external IP** value
shown.

1. Get the ingress IP address and point your DNS records from your custom domain
   to the external IP address you obtained in the previous step.

> If your custom domain uses the HTTPS protocol, make sure that you have
> [TLS certificates](../guides/tls-certificates/index.md) for use with your
> Coder deployment. Otherwise, you can skip this step.

## Step 2: Update the Helm chart and redeploy Coder

When changing your access URL, you'll need to
[update your Helm chart](../guides/admin/helm-charts.md) and
[redeploy Coder](../setup/updating.md):

helm upgrade coder coder/coder \
 --set devurls.host="\*.example.com" \
 --set ingress.host="coder.example.com" \

> See the [enterprise-helm repo](https://github.com/cdr/enterprise-helm) for
> more information on Coder's Helm charts.

## Step 3: Provide the access URL in the Coder UI

1. Log into Coder as a site admin/site manager and go to **Manage** >
   **Admin** > **Infrastructure**.

1. Provide your custom domain in the **Access URL** field. The URL you provide
   must match the value you provided as `ingress.host` in the previous step.
