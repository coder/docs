---
title: Tailscale
description: Learn how to use Tailscale in your Coder workspace.
---

This guide walks you through configuring [Tailscale networking] for use inside
[Coder workspaces]. With Tailscale networking, you can access services running
inside Coder and services running on your [tailnet (Tailscale private network)].

[tailscale networking]: https://tailscale.com/
[tailnet (tailscale private network)]: https://tailscale.com/kb/1136/tailnet/
[coder workspaces]: ../../workspaces/index.md

## Creating the image

As part of this tutorial, you'll create an image with the following that you'll
use to create new Coder workspaces. The container image will include:

- The Tailscale daemon (`tailscaled`)
- A transparent proxy tool (`proxychains4`)
- Environment variables to control proxy behavior for outbound connections
- A [SOCKS5 proxy] included in `tailscaled` to facilitate connections to the
  tailnet, listening on `localhost:1080`
- An [HTTP proxy] included in `tailscaled` to facilitate connections to the
  tailnet, listening on `localhost:3128`

[socks5 proxy]: https://en.wikipedia.org/wiki/SOCKS
[http proxy]: https://en.wikipedia.org/wiki/Proxy_server#Web_proxy_servers

## Limitations

This guide describes how to install Tailscale in a Ubuntu base image using the
package manager and running it in userspace networking mode. As such:

- The image (which you will create as part of this tutorial) requires
  [container-based virtual machine] workspaces, so that `systemd` can start the
  Tailscale daemon (`tailscaled`)
- Users will require `sudo` access to configure the Tailscale tunnel
- Inbound connections from other devices on the tailnet to your workspace will
  appear to originate from `localhost`
- Outbound connections to other devices on the tailnet will require support for
  HTTP proxies; otherwise, you'll need to use a wrapper such as `proxychains4`
- The example in this article applies to Ubuntu 20.04 LTS (Focal Fossa), so you
  may need to adapt it for compatibility with your preferred base image

Tailscale does not require root access to operate in userspace networking mode,
and the requirement to use [container-based virtual machine] workspaces applies
only to the instructions in this guide. [Contact our support team] if you are
interested in using Tailscale in your Coder workspace without root access.

[contact our support team]: ../../feedback.md
[container-based virtual machine]: ../../workspaces/cvms.md

## Step 1: Create the Dockerfile

In Coder, developer workspaces are defined by a Dockerfile that contains the
apps, tools, and dependencies that you need to work on the project.

> See our [custom image docs] and Docker’s [guide to writing Dockerfiles] for
> more information.

[custom image docs]: ../../images/writing
[guide to writing dockerfiles]:
  https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

To simplify creating and maintaining the image, we recommend structuring your
source code so that files added or modified in the image match the hierarchy of
the target files, in a subdirectory called `files`:

```text
.
├── Dockerfile
└── files
    ├── etc
    │   ├── apt
    │   │   ├── preferences.d
    │   │   │   └── tailscale
    │   │   └── sources.list.d
    │   │       └── tailscale.list
    │   └── systemd
    │       └── system
    │           └── tailscaled.service.d
    │               └── tailscale.conf
    └── usr
        └── share
            └── keyrings
                └── tailscale.gpg
```

While it is possible to configure everything directly in a single Dockerfile, we
recommend using a folder hierarchy, since this makes it easier to create a
reproducible image and examine the change history for individual files.

Create the folder hierarchy:

```console
mkdir --parents \
    files/etc/apt/preferences.d \
    files/etc/apt/sources.list.d \
    files/etc/systemd/system/tailscaled.service.d \
    files/usr/share/keyrings
```

Then, create the following files (we'll walk you through the contents of each in
the following steps):

```console
touch files/etc/apt/preferences.d/tailscale \
    files/etc/apt/sources.list.d/tailscale.list \
    files/etc/systemd/system/tailscaled.service.d/tailscale.conf
```

### Step 1a: Add image repository

Add the Tailscale package repository to `tailscale.list` in the local path
`files/etc/apt/sources.list.d`. This will appear in `/etc/apt/sources.list.d` in
the resulting image, with the following contents:

```text
deb [signed-by=/usr/share/keyrings/tailscale.gpg] https://pkgs.tailscale.com/stable/ubuntu focal main
```

This configures `apt` and `apt-get` to install packages from the Tailscale
repository and verify package signatures with the specified public key.

### Step 1b: (Optional) Configure package pinning

For improved security, you can configure `apt` to deny package installation from
a given repository by default and allow specific packages by name. To do this,
create `files/etc/apt/preferences.d/tailscale` with the following contents:

```text
# Ignore all packages from this repository by default
Package: *
Pin: origin pkgs.tailscale.com
Pin-Priority: 1

Package: tailscale
Pin: origin pkgs.tailscale.com
Pin-Priority: 500
```

### Step 1c: Add the signing key for Tailscale package repository

Retrieve the signing key from Tailscale, and store the binary (dearmored) key
file in `files/usr/share/keyrings/tailscale.gpg`:

```console
curl --silent --show-error --location "https://pkgs.tailscale.com/stable/ubuntu/focal.gpg" | \
    gpg --dearmor --yes --output=files/usr/share/keyrings/tailscale.gpg
```

### Step 1d: Override default `tailscaled` service settings

By default, `tailscaled` will store its internal state in a **state file**
located at `/var/lib/tailscale/tailscaled.state` (this is is ephemeral in
Coder). We will need to modify the service settings to:

- Store the state file in the persistent home volume (`/home/coder`)
- Enable userspace networking
- Enable the SOCKS5 proxy (optional)
- Enable the HTTP proxy (optional)

If you do not require outbound connections from the workspace to other services
running in the tailnet, you may skip the steps where you configure the proxies.

Override the `ExecStart` setting for the `tailscaled` service by saving the
following to `files/etc/systemd/system/tailscaled.service.d/tailscale.conf`:

```text
[Service]
ExecStart=
ExecStart=-/usr/sbin/tailscaled --state=/home/coder/.config/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock --port $PORT --tun=userspace-networking --socks5-server=localhost:1080 --outbound-http-proxy-listen=localhost:3128 $FLAGS
```

### Step 1e: Create the Dockerfile

Create a `Dockerfile`, build it, and push to an external repository, such as
Docker Hub:

```Dockerfile
FROM codercom/enterprise-base:ubuntu

USER root

# Copy configuration files to appropriate locations
COPY files /

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get install --no-install-recommends --yes --quiet \
      netcat-openbsd \
      proxychains4 \
      python3 && \
    apt-get install --no-install-recommends --yes --quiet \
      tailscale && \
    # Delete package cache to avoid consuming space in layer
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER coder

ENV ALL_PROXY=socks5://localhost:1080
ENV http_proxy=http://localhost:3128
```

## Step 2: Authenticate to Tailscale

[Create a workspace] using the container image. Initially, `tailscaled` should
be running, but it will indicate that it requires authentication:

```console
systemctl status tailscaled
```

Authenticate using `sudo tailscale up`, then verify that other network devices
are visible:

```console
tailscale status
```

> You may also use a [pre-authentication key] with `tailscale up --authkey` to
> avoid needing to sign in via a web browser.

[pre-authentication key]: https://tailscale.com/kb/1085/auth-keys/

`tailscale` should maintain connectivity across workspace rebuilds, since we
chose to store the state file in a persistent volume.

[create a workspace]: ../../workspaces/create.md

## Step 3: (Optional) Test Tailscale services

By creating two workspaces from the same image, both authenticated to Tailscale,
we can verify connectivity works as expected. In one workspace, run the Python
web server:

```console
python3 -m http.server 3000
```

In another workspace, verify that `tailscaled` is listening for connections on
the configured proxy ports:

```console
ss -nltp
```

Check that the `http_proxy` environment variable is set to the address of the
local `tailscaled` proxy:

```console
env | grep -i proxy
```

Run `curl` (which respects the `http_proxy` command) to connect to the webserver
running in the other workspace. Since we proxy the connection through the local
`tailscaled` instance, we can use the internal hostname:

```console
curl http://jawnsy-tailscale-1:3000
```

For applications that do not respect the `http_proxy` or `ALL_PROXY` environment
variables, consider using a tool like `proxychains4` to intercept the socket
system calls and transparently route traffic through the proxy.
