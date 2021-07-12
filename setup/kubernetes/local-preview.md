---
title: "Local preview"
description: Set up a Coder deployment locally for testing.
---

Coder is typically deployed onto Kubernetes cluster, but if you would like to
set up a lightweight preview deployment, you can do so locally using using
[Docker][docker-url] and [kind][kind-url].

> Coder currently supports local preview only on workstations running macOS or
> Linux.

Coder automatically uploads a single-seat license upon installation.

## Prerequisites

Before proceeding, please make sure that you have the following installed:

1. [Docker](https://hub.docker.com/search?q=docker&type=edition&offering=community)
1. [helm](https://helm.sh/docs/intro/install)
1. [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
1. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)

## Limitations

### Resource allocation and performance

Your experience with the local Coder preview is dependent on your system specs,
but please note that you can expect slightly degraded performance due to the
deployment running entirely inside a Docker container.

### CVMs

The local preview supports [CVMs][cvm-url] if you meet the following
requirements (if you choose not to try out CVMs, these requirements do not
apply):

1. Your Linux hosts must be running Linux Kernel 5 and above.

1. You must have the `linux-headers` package corresponding to your Kernel
   version installed. You should see the following folders all corresponding to
   your Kernel version:

   ```console
   $ uname -r
   5.11.4-arch1-1
   $ ls /usr/lib/modules
   5.11.4-arch1-1
   $ ls /usr/src/
   linux  linux-headers-5.11.4-arch1-1
   ```

1. Docker Desktop for Mac **must** use version [2.5.0.1][docker-mac-url]. This
   specific version is required because of a recent downgrade to Linux Kernel
   4.9 due to a [bug][docker-bug-url].

### Dev URLs

When Coder is installed, dev URLs are not enabled by default.

To enable local dev URLs, follow
[the instructions below](#enable-local-dev-urls) after installing Coder.

If you do not want to enable dev URLs, you can use SSH portforwarding or tools
like [ngrok][ngrok-url] to preview webpages from inside a workspace.

### Air-gapped clusters

The local preview option does not work in an air-gapped deployment.

## Installing Coder

To install Coder, run:

```console
curl -fsSL https://coder.com/try.sh | PORT="80" sh -s --
```

> Note: you can edit the value of `PORT` to control where the Coder dashboard
> will be available. However, dev URLs will only work when PORT is 80

When the installation process completes, you'll see the URL and login
credentials you need to access Coder:

```txt
You can now access Coder at

    http://localhost:80

You can tear down the deployment with

    curl -fsSL https://coder.com/try.sh | sh -s -- down

Platform credentials
User:     admin
Password: yfu...yu2
```

Visit the URL, and log in using the provided credentials. The platform is
automatically configured for you, so there's no first-time setup to do.

## Enable local dev URLs

A wildcard subdomain is required to use dev URLs with Coder. One option is to
use a service such as [nip.io][nip-url] to route domains local IP.

[Update Coder](https://coder.com/docs/coder/latest/setup/updating#update-coder)
with the following helm values added for either your local (127.0.0.1) or
private (e.g 192.168.1.x) address:

```yaml
ingress:
  host: "127.0.0.1.nip.io"
devurls:
  host: "*.127.0.0.1.nip.io"
```

Alternatively, [dnsmasq][dnsmasq-url] can be used to create local domains (e.g
`http://dashboard.coder` and `http://*.coder`). This may be useful if you do not
want to rely on an external service/network, or if your network has DNS
rebinding protection. Here's how:

1. Install dnsmasq

   ```console
   # Mac OS
   brew install dnsmasq

   # Linux (Ubuntu)
   sudo apt-get install dnsmasq
   ```

1. Create dnsmasq configuration for the .coder domain

   ```console
   # Mac OS
   sudo touch $(brew --prefix)/etc/dnsmasq.d/coder.conf
   sudo vim $(brew --prefix)/etc/dnsmasq.d/coder.conf

   # Linux (Ubuntu)
   sudo touch /etc/dnsmasq.d/coder.conf
   sudo vim /etc/dnsmasq.d/coder.conf
   ```

   ```conf
   # coder.conf
   address=/coder/127.0.0.1
   ```

1. Add dnsmasq as DNS resolver on your machine

   ```console
   # Mac OS: this will only route
   # .coder domains to dnsmasq
   sudo mkdir -p /etc/resolver
   sudo touch /etc/resolver/
   sudo vim /etc/resolver/coder

   # Linux (Ubuntu)
   # add to top of the file
   sudo vim /etc/resolv.conf
   ```

   ```text
   nameserver 127.0.0.1
   ```

1. To use the new domains, [update Coder](../updating#update-coder) with these
   helm values added:

   ```yaml
   ingress:
   host: "dashboard.coder"
   devurls:
   host: "*.coder"
   ```

## Removing Coder

To remove the local Coder deployment, run:

```console
curl -fsSL https://coder.com/try.sh | sh -s -- down
```

Because Coder runs inside Docker, you should have nothing left on your machine
after tear down.

If you added custom DNS for [local dev URLs](#enable-local-dev-urls), you can
revert these changes by uninstalling dnsmasq and removing the resolver config:

```console
# MacOS
brew remove dnsmasq
sudo rm -r /etc/resolver/coder

# Linux (Ubuntu)
sudo apt-get remove dnsmasq
sudo vim /etc/resolv.conf
# remove "nameserver 127.0.0.1"
# and ensure you have another
# nameserver specified
# e.g "nameserver 127.0.0.53"
```

[docker-url]: https://www.docker.com/
[dnsmasq-url]: https://linux.die.net/man/8/dnsmasq
[kind-url]: https://kind.sigs.k8s.io/
[cvm-url]: https://coder.com/docs/workspaces/cvms
[docker-mac-url]:
  https://docs.docker.com/docker-for-mac/release-notes/#docker-desktop-community-2501
[docker-windows-url]:
  https://docs.docker.com/docker-for-windows/release-notes/#docker-desktop-community-2501
[docker-bug-url]: https://github.com/docker/for-mac/issues/5044
[ngrok-url]: https://ngrok.com
[devurl-url]: https://coder.com/docs/workspaces/devurls
[nip-url]: https://nip.io
