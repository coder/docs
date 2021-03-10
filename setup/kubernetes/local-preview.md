---
title: "Local Preview"
description: Set up a Coder deployment locally for testing.
---

Coder is typically deployed onto Kubernetes cluster, but if you would like to
set up a lightweight preview deployment, you can do so locally using using
[Docker][docker-url] and [kind][kind-url].

> Coder currently supports local preview only on workstations running macOS or
> Linux.

## Prerequisites

Before proceeding, please make sure that you have the following installed:

1. [Docker](https://hub.docker.com/search?q=docker&type=edition&offering=community)
1. [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
1. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)
1. [helm](https://helm.sh/docs/intro/install)

## Limitations

### CVMs

[CVMs][cvm-url] are supported in local previews with some caveats.

1. Linux hosts must be running Linux Kernel 5 and above.
    * Additionally, you'll need the `linux-headers` package installed for the
      running Kernel version. You should see the following folders correspond
      to the current Kernel version:

      ```bash
      $ uname -r
      5.11.4-arch1-1
      $ ls /usr/lib/modules
      5.11.4-arch1-1
      $ ls /usr/src/
      linux  linux-headers-5.11.4-arch1-1
      ```

1. Docker Desktop for Mac must use version [2.5.0.1][docker-mac-url].
    * This versions is necessary due to a recent downgrade to Linux Kernel 4.9
      because of a [bug](docker-bug-url).

If you choose not to try out CVMs, these requirements are not necessary.

### Dev URLs

Currently, the local preview doesn't support [Dev URLs][devurl-url]. Tools such
as [ngrok][ngrok-url] can be used to preview webpages from inside an
environment.

We are working on bringing Dev URL support to local previews in later releases.

## Installing Coder

To install Coder, run:

```bash
curl -fsSL https://coder.com/try.sh | PORT="8080" sh -s --
```

> Note: you can edit the value of `PORT` to control where the Coder
> dashboard will be available.

When the installation process completes, you'll see the URL and login
credentials you need to access Coder:

```txt
You can now access Coder at

    http://localhost:8080

You can tear down the deployment with

    curl -fsSL https://coder.com/try.sh | sh -s -- down

Platform credentials
User:     admin
Password: yfu...yu2
```

Visit the URL, and log in using the provided credentials. The platform is
automatically configured for you, so there's no first time setup to do.

## Removing Coder

To remove the local Coder deployment, run:

```bash
curl -fsSL https://coder.com/try.sh | sh -s -- down
```

Because Coder runs inside Docker, you should have nothing left on your machine
after tear down.

[docker-url]: https://www.docker.com/
[kind-url]: https://kind.sigs.k8s.io/
[cvm-url]: https://coder.com/docs/environments/cvms
[docker-mac-url]: https://docs.docker.com/docker-for-mac/release-notes/#docker-desktop-community-2501
[docker-windows-url]: https://docs.docker.com/docker-for-windows/release-notes/#docker-desktop-community-2501
[docker-bug-url]: https://github.com/docker/for-mac/issues/5044
[ngrok-url]: https://ngrok.com
[devurl-url]: https://coder.com/docs/environments/devurls
