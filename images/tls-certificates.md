# TLS certificates

This article will show you how to correct issues regarding TLS certificates in
Coder.

## Background

Coder may sometimes fail to download extensions for your IDE if the remote
extension marketplace URL is untrusted. This might happen for one of the
following reasons:

- The image doesn't come with any ca-certificates
- You're using an internal certificate authority

Coder workspaces may also fail to build if the TLS certificate used by Coder is
not present in the image, or if there is some issue with the certificate.

## Adding certificates for Coder

To add certificates to your image and have them recognized by Coder:

1. Add the certificate(s) to the image
1. Set the `NODE_EXTRA_CA_CERTS` environment variable to the file in the image
   that contains the certificates
1. Add the following to your Dockerfile to ensure that Coder finds and uses your
   newly added certificates when making requests:

   ```Dockerfile
    COPY my-certs.crt /etc/ssl/certs/my-certs.crt
    ENV NODE_EXTRA_CA_CERTS /etc/ssl/certs/my-certs.crt
   ```

## Adding certificates at the system level

You can add certificates at the system level so that any process that runs
within the workspace will use the certificates when making requests.

The specific process to add system-level certificates depends on the Linux
distribution that you're using, but it is typically done by adding your
certificates to your system's trusted CA repository.

## TLS Certificate Requirements

Since the publication of RFC 2818 in 2000, the `commonName` field has been
[considered deprecated](https://groups.google.com/a/chromium.org/g/security-dev/c/IGT2fLJrAeo/m/csf_1Rh1AwAJ).

The Go programming language, which Coder uses, recently began enforcing this and
ignoring the `commonName` field (source) in favor of the Subject Alternative
Name (SAN) field.

This essentially means that SSL certificates are required to use
`Subject Alternative Name` instead of `commonName`. If you attempt to use a
certificate having `commonName` with Coder, you may see the following error:

```shell
x509: certificate relies on legacy Common Name field, use SANs instead
```

Certificates may specify both fields for interoperability with existing software
that requires the `commonName` field.

If you see this error when building a workspace or performing other operations
with Coder workspaces, you may be running into the aforementioned issue. To
verify that this is the case, you can inspect the certificate of your Coder
deployment with the following command:

```shell
openssl s_client -connect coder.domain.tld:443 < /dev/null 2>/dev/null \|
sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \|
openssl x509 -text -noout \|
grep -A1 'Subject Alternative Name'
```

If your certificate has SANs specified, the expected output for the above
command would be similar to the following:

```shell
           X509v3 Subject Alternative Name:
                DNS:*.coder.domain.tld, DNS:coder.domain.tld, DNS:domain.tld
```

Otherwise, a blank output is expected.

To fix the issue, a new TLS certificate is required that does not rely solely on
the `commmonName` field. In the above example, this would equate to adding the
following arguments to the `openssl` invocation to generate the certificate:

```shell
-addext "subjectAltName = DNS:domain-name.com"
```
