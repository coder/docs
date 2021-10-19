---
title: Tailscale
description: Learn how to use Tailscale in your Coder workspace.
---

This guide describes how to configure [Tailscale networking] for use inside
[Coder workspaces], so that you can access services running inside Coder as well
as other services running on your [tailnet (Tailscale private network)]. The
container image you'll create will include:

- The tailscale daemon (`tailscaled`)
- A transparent proxy tool, `proxychains4`
- Environment variables to control proxy behavior for outbound connections
- A [SOCKS5 proxy] listening for connections on `localhost:1080`
- A [HTTP proxy] listening for connections on `localhost:3128`

[tailscale networking]: https://tailscale.com/
[tailnet (tailscale private network)]: https://tailscale.com/kb/1136/tailnet/
[coder workspaces]: ../../workspaces/index.md
[socks5 proxy]: https://en.wikipedia.org/wiki/SOCKS
[http proxy]: https://en.wikipedia.org/wiki/Proxy_server#Web_proxy_servers

## Limitations

This guide describes how to install Tailscale in a Ubuntu base image using the
package manager and running it in userspace networking mode. As a consequence:

- The image requires [Container-based Virtual Machine] workspaces, so that
  systemd can start the tailscale daemon (`tailscaled`)
- Users will require `sudo` access in order to configure the tailscale tunnel
- Inbound connections from other devices on the tailnet to your workspace will
  appear to originate from localhost
- Outbound connections to other devices on the tailnet will require support for
  HTTP proxies, or use a wrapper such as `proxychains4`
- This example applies to Ubuntu 20.04 LTS (Focal Fossa), and you may need to
  adapt it for compatibility with your preferred base image

Tailscale does not require root access to operate in userspace networking mode,
and the requirement to use [Container-based Virtual Machine] workspaces applies
only to the instructions in this guide. [Contact our support team] if you are
interested in using Tailscale in your Coder workspace without root access.

[contact our support team]: ../../feedback.md
[container-based virtual machine]: ../../workspaces/cvms.md

## Step 1: Create the Dockerfile

In Coder, developer workspaces are defined by a Dockerfile that contains the
apps, tools, and dependencies that you need to work on the project.

> See Docker’s [guide to writing Dockerfiles] for more information.

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
recommend using a folder hierarchy, since it makes it easier to create a
reproducible image and examine the change history for individual files.

Create the folder hierarchy using:

```console
$ mkdir --parents --verbose \
    files/etc/apt/preferences.d \
    files/etc/apt/sources.list.d \
    files/etc/systemd/system/tailscaled.service.d \
    files/usr/share/keyrings
mkdir: created directory 'files'
mkdir: created directory 'files/etc'
mkdir: created directory 'files/etc/apt'
mkdir: created directory 'files/etc/apt/preferences.d'
mkdir: created directory 'files/etc/apt/sources.list.d'
mkdir: created directory 'files/etc/systemd'
mkdir: created directory 'files/etc/systemd/system'
mkdir: created directory 'files/etc/systemd/system/tailscaled.service.d'
mkdir: created directory 'files/usr'
mkdir: created directory 'files/usr/share'
mkdir: created directory 'files/usr/share/keyrings'
```

## Step 1a: Add image repository

Add the Tailscale package repository to `tailscale.list` in the local path
`files/etc/apt/sources.list.d`, which will appear in `/etc/apt/sources.list.d`
in the resulting image, with the following contents:

```text
# Tailscale packages for ubuntu focal
deb [signed-by=/usr/share/keyrings/tailscale.gpg] https://pkgs.tailscale.com/stable/ubuntu focal main
```

This configures `apt` and `apt-get` to install packages from the Tailscale
repository, verifying package signatures with the specified public key.

## Step 1b: Configure package pinning (optional)

For improved security, you can configure `apt` to deny package installation from
a given repository by default, and allow specific packages by name. To do this,
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

## Step 1c: Add signing key for Tailscale package repository

Retrieve the signing key from Tailscale and store the binary (dearmored) key
file in `files/usr/share/keyrings/tailscale.gpg`:

```console
$ curl --silent --show-error --location "https://pkgs.tailscale.com/stable/ubuntu/focal.gpg" | \
    gpg --dearmor --yes --output=files/usr/share/keyrings/tailscale.gpg
```

## Step 1d: Override default tailscaled service settings

By default, tailscaled will store its internal state in a "state file" located
at `/var/lib/tailscale/tailscaled.state`, which is ephemeral in Coder. We will
need to modify the service settings in order to:

- Store the state file in the persistent home volume (`/home/coder`)
- Enable userspace networking
- Enable the SOCKS5 proxy (optional)
- Enable the HTTP proxy (optional)

If you do not require outbound connections from the workspace to other services
running in the tailnet, you may skip configuring the proxies.

Override the `ExecStart` setting for the `tailscaled` service by saving the
following to `files/etc/systemd/system/tailscaled.service.d/tailscale.conf`:

```text
[Service]
ExecStart=
ExecStart=-/usr/sbin/tailscaled --state=/home/coder/.config/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock --port $PORT --tun=userspace-networking --socks5-server=localhost:1080 --outbound-http-proxy-listen=localhost:3128 $FLAGS
```

## Step 1e: Create the Dockerfile

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

Start a workspace using the container image. Initially, `tailscaled` should be
running, but will indicate that it requires authentication:

```console
$ systemctl status tailscaled
● tailscaled.service - Tailscale node agent
     Loaded: loaded (/lib/systemd/system/tailscaled.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/tailscaled.service.d
             └─tailscale.conf
     Active: active (running) since Tue 2021-10-19 21:32:52 UTC; 1min 18s ago
       Docs: https://tailscale.com/kb/
    Process: 1464 ExecStartPre=/usr/sbin/tailscaled --cleanup (code=exited, status=0/SUCCESS)
   Main PID: 1511 (tailscaled)
     Status: "Stopped; run 'tailscale up' to log in"
      Tasks: 18 (limit: 309528)
     Memory: 16.7M
     CGroup: /system.slice/tailscaled.service
             └─1511 /usr/sbin/tailscaled --state=/home/coder/.config/tailscaled.state --socket
```

Authenticate using `sudo tailscale up`, then verify that other network devices
are visible:

```console
$ tailscale status
100.101.102.103 ("hello")            services@    linux   -
100.90.56.90    jawnsy-tailscale-1   jonathan@    linux   -
100.93.121.122  jawnsy-tailscale-2   jonathan@    linux   -
```

`tailscale` should maintain connectivity across workspace rebuilds, since we
chose to store the state file in a persistent volume.

## Step 3: Test Tailscale services (optional)

By creating two workspaces from the same image, authenticated to Tailscale, we
can verify connectivity works as expected. In one workspace, run the Python web
server:

```console
$ python3 -m http.server 3000
Serving HTTP on 0.0.0.0 port 3000 (http://0.0.0.0:3000/) ...
```

From another workspace, verify that `tailscaled` is listening for connections on
the configured proxy ports:

```console
$ ss -nltp
State     Recv-Q     Send-Q         Local Address:Port          Peer Address:Port    Process
LISTEN    0          1024               127.0.0.1:3128               0.0.0.0:*
LISTEN    0          1024               127.0.0.1:1080               0.0.0.0:*
```

Check that the `http_proxy` environment variable is set to the address of the
local `tailscaled` proxy:

```console
$ env | grep -i proxy
http_proxy=http://localhost:3128
ALL_PROXY=socks5://localhost:1080
```

Run `curl` (which respects the `http_proxy` command) to connect to the web
server running in the other workspace. Since we proxy the connection through the
local `tailscaled` instance, we can use the internal host name:

```console
$ curl http://jawnsy-tailscale-1:3000
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
```

For applications that do not respect the `http_proxy` or `ALL_PROXY` environment
variables, consider using a tool like `proxychains4` to intercept the socket
system calls and transparently route traffic through the proxy.
