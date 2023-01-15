# Self-contained workspace builds

Currently, there are two ways in which the workspace boot sequence can occur:

1. Remotely: Coder uploads assets (including the Coder agent, code-server, and
   JetBrains Projector) from `coderd` to a workspace.
1. Self-contained: workspaces control the boot sequence internally; the
   workspace downloads assets from `coderd`. This requires `curl` to be
   available in the image.

Beginning with v1.30.0, the default is **self-contained workspace builds**,
though site managers can toggle this feature off and opt for remote builds
instead.

To toggle self-contained workspace builds:

1. Log into Coder.
1. Go to Manage > Admin.
1. On the Infrastructure page, scroll down to **Workspace container runtime**.
1. Under **Enable self-contained workspace builds**, flip the toggle to **On**
   or **Off** as required.
1. Click **Save workspaces**.

> Build errors are typically more verbose for remote builds than with
> self-contained builds.

## Troubleshooting

In certain cases, your workspace may not trust the `coderd` TLS certificate.
This will result in the error below:

```console
stream logs from workspace: Failed to create Container-based Virtual Machine
```

To resolve this, you will need to copy the `coderd` TLS certificate into
your Docker image's certificate trust store. Below are examples for doing so,
for the major distributions:

### Debian and Ubuntu distributions

```Dockerfile
RUN apt-get install -y ca-certificates
COPY my-cert.pem /usr/local/share/ca-certificates/my-cert.pem
RUN update-ca-certificates
```

### CentOS, Fedora, RedHat distributions

```Dockerfile
RUN yum install ca-certificates && update-ca-trust force-enable
COPY my-cert.pem /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust extract
```
