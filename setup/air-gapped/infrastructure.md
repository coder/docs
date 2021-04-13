---
title: Air-Gapped Network Setup
description: Learn how to set up a network for air-gapped Coder deployment.
---

This article walks you through setting up the supporting infrastructure for an
air-gapped Coder deployment.

If the network that will run Coder already has the following, skip this tutorial
and proceed with [the installation](../air-gapped) process:

- A certificate authority
- A domain name service
- A local Docker Registry

> The code snippets provided in this article are sourced from third-party
> software packages. While we attempt to keep this article up-to-date, we
> strongly recommend that you verify the snippets before using them.

## Creating the local registry and generating a self-signed certificate

Coder needs an image registry to store your images. It uses Docker's Registry
2.0 implementation, which supports self-signed certificates and assumes that the
protocol used will be HTTPS. The following steps will show you how to make sure
the registry works.

Before starting the registry container, create a self-signed certificate:

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

Before the Kubernetes node can accept run local images, it needs to consider the
new `registry.crt` file as trusted. The specific locations and methods to store
and trust the certificate vary depending on the Linux distribution and the
container runtime, but here is a partial list to help you get started:

```plaintext
/usr/local/share/ca-certificates/registry.crt
/etc/docker/certs.d/${REGISTRY_DOMAIN_NAME}/ca.crt
/etc/ssl/certs/registry.crt
/etc/pki/tls/registry.crt
```

If the cluster uses containerd, apply the following to patch in certificates for
images in the local registry domain:

```console
update-ca-certificates
cat <<EOT >> /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".registry.configs."$REGISTRY_DOMAIN_NAME".tls]
  insecure_skip_verify = true
EOT
systemctl restart containerd
```

Because the steps described in this section must be run on all nodes which will
be scheduling Coder images, either:

1. Include these steps in the image
1. Run an init script that includes these instructions whenever you add a new
   node to your cluster

## Adding certificate secrets to the Helm chart

Coder validates images and pulls tags using REST API calls to the registry.
Other internal services (OIDC, Git providers, etc) that use HTTPS APIs require
the Coder container to trust the certificate. You can fix this by adding a root
CA certificate to the Coder service images via the Coder helm chart.

To pass a self-signed certificate to Coder's images, you'll need to:

1. Create a secret
1. Reference the secret in your Coder Helm chart

To create a secret, run:

```console
kubectl -n coder create secret generic local-registry-cert --from-file=/certs
```

When using the above command, `kubectl` creates the secret from a directory
containing a single file. The directory name doesn't matter, but the filename
becomes the secret **key**.

> If you changed the `-keyout` argument on the OpenSSL command used to generate
> the certificates, or if you moved the certificates, make sure that you adjust
> the path included with `--from-file=`.

To verify the new secret:

```console
kubectl -n coder get secret local-registry-cert -o yaml
```

Refer to the new secret from the Helm chart by adding the following snippet into
a YAML file named `registry-cert-values.yml`:

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

Nodes must be able to resolve the `$REGISTRY_DOMAIN` name of the local
registry's static IP address. One way to do this without an external DNS server
is to use the node's hosts file. For example, if the registry is on 10.0.0.2,
then add this to the Node configuration script:

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
