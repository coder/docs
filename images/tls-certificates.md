# TLS certificates

This article will show you how to correct issues regarding TLS certificates in
Coder.

## Background

Coder may sometimes fail to download extensions for your IDE if the remote
extension marketplace URL is untrusted. This might happen for one of the
following reasons:

- The image doesn't come with any ca-certificates
- You're using an internal certificate authority

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
