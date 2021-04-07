---
title: Air-Gapped Network Setup
description: Learn how to set up a network for air-gapped Coder deployment.
---

This article will walk you through setting up your network to support an
air-gapped Coder deployment.

If your network already has the following, you can proceed with your
installation:

- A certificate authority
- A domain name service
- A local Docker Registry

> The code snippets provided in this article are sourced from third-party
> software packages. While we attempt to keep this article up-to-date, we
> strongly recommend that you verify the snippets as well before using.

## Creating the local registry and generating a self-signed certificate

You will need to create a local registry to store your Coder images and
self-signed certificates (you can use self-signed certificates in any
environment, but they're required for air-gapped deployments).

You can create your local registry to and your self-signed certificate at the
same time:

```bash
export REGISTRY_DOMAINNAME=registry.local
mkdir /certs
openssl req \
    -newkey rsa:4096 -nodes -sha256 -keyout /certs/registry.key \
    -x509 -days 365 -out /certs/registry.crt
```

The console will prompt you for `Common Name [CN]:`; provide the value that
matches exactly what you set with your DNS. For the volume mounted at
`/var/lib/registry`, make sure that it has at least 10 GB for Coder images.

Start the registry container that you just created:

```bash
docker run -d -p 443:5000 \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
    -v /certs:/certs \
    -v /var/lib/docker/registry:/var/lib/registry \
    registry:2
```

> For the volume mounted at `/var/lib/registry` make sure it can store 10+ GB
> for just Coder images.

## Configuring the Kubernetes Node

Before the Kubernetes node can accept your certificate, you'll need to mark your
`registry.crt` file as trusted. The specific locations where you need to have
this file depends on your Linux distribution and the container runtime:

```plaintext
/usr/local/share/ca-certificates/registry.crt
/etc/docker/certs.d/${REGISTRY_DOMAIN_NAME}/ca.crt
/etc/ssl/certs/registry.crt
/etc/pki/tls/registry.crt
```

If you're working with containerd, use the following to patch in certificates
for images in the local registry domain:

```console
update-ca-certificates
cat <<EOT >> /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".registry.configs."$REGISTRY_DOMAIN_NAME".tls]
  insecure_skip_verify = true
EOT
systemctl restart containerd
```

Because you'll need to run the steps described in this section on all nodes that
will be scheduling Coder images, we recommend that you either:

1. Include these steps in the image itself
1. Run an init script including these instructions whenever you add a new node
   to your cluster

## Adding certificate secrets to the Helm chart

Coder validates images and pulls tags using API calls, so issues with your
certificates may prevent you from adding images. If you see such issues and you
have a certificate authority in your network, you may need to add the root
certificate.

To pass a self-signed certificate to Coder's images, you'll need to:

1. Create a secret
1. Reference the secret in your Coder Helm chart

To create a secret, run:

```console
kubectl -n coder create secret generic local-registry-cert --from-file=/certs
```

When using the above command, you're creating the secret from a directory with a
single file. The directory name doesn't matter, but the filename becomes the
secret **key**.

> If you changed the `-out` argument on the OpenSSL command used to generate the
> certificates, or if you moved the certificates, make sure that you adjust the
> path included with `--from-file=`.

To verify your secret:

```console
kubectl -n coder get secret local-registry-cert -o yaml
```

You'll need to add your secret to the Helm chart, and you can do this as part of
your verification step. To do so, place the following snippet into a YAML file
named `registry-cert-values.yml`:

```yaml
certs:
  secret:
    name: "local-registry-cert"
    key: "registry.crt"
```

Then, add the flag `-f registry-cert-values.yml` to the end of the secret
verification immediately above:

```console
kubectl -n coder get secret local-registry-cert -o yaml -f registry-cert-values.yml
```

### Resolving the registry using the cluster's DNS or hostAliases

Your Nodes must have their host file set to the `$REGISTRY_DOMAIN` and the
static IP address of the local registry. For example, if the registry is on
10.0.0.2, then add this to your Node configuration script:

```console
echo "10.0.0.2 $REGISTRY_DOMAIN_NAME" >> /etc/hosts
```

> This modification may not help the containers _within_ the cluster, since
> Kubernetes forwards some of its DNS services out of the cluster. If, at a
> later point, you discover that the hosts file on the node isn't being heeded
> by pods, you can work around this by extracting the Helm chart from
> `coder-X.Y.Z.tgz` and patching the ce-manager deployment (this goes at the
> same indentation level as `containers:`):
>
> ```yaml
> hostAliases:
>   - hostnames:
>       - $REGISTRY_DOMAIN_NAME
>     ip: 10.0.0.2
> ```
