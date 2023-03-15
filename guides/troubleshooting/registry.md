# Image registry

When configuring Coder to use a local image registry in an air-gapped network,
you may encounter an error similar to the following:

```console
An error occurred while submitting

unable to ping registry for 'new transport: Get "https://registry-url.org": x509:
certificate signed by unknown authority
```

## Why this happens

The local registry you are configuring is expecting a valid certificate to
authenticate the connection with Coder. You will receive this error if:

- You do not have a certificate configured
- There is an issue with the certificate itself

> Coder uses Docker's Registry 2.0 implementation, which supports self-signed
> certificates and assumes that the protocol you're using will be HTTPS.

## Troubleshooting steps

- If you haven't created the local registry, and you haven't generated the
  self-signed certificate,
  [please see our documentation](../../setup/air-gapped/infrastructure.md) on
  setting these up.

- Check to see if your `registry.crt` file is stored in the correct location on
  each of your Kubernetes nodes. Depending upon your Linux distribution and
  container runtime, it may be in any of the following locations:

  ```console
  /usr/local/share/ca-certificates/registry.crt
  /etc/docker/certs.d/${REGISTRY_DOMAIN_NAME}/ca.crt
  /etc/ssl/certs/registry.crt
  /etc/pki/tls/registry.crt
  ```

- If your cluster uses `containerd`, ensure the following patch has been applied
  to the `/etc/containerd/config.toml` file:

  ```console
  [plugins."io.containerd.grpc.v1.cri".registry.configs."$REGISTRY_DOMAIN_NAME".tls]
    insecure_skip_verify = true
  ```

Ensure that you've created the self-signed certificate secret in your Kubernetes
cluster:

```console
kubectl -n coder get secret local-registry-cert -o yaml
```

If none of these steps resolve the issue, please
[contact us](https://coder.com/contact) for further support.
