---
title: "Local Preview"
description: Set up a Coder deployment locally for testing.
---

Coder is typically deployed onto Kubernetes cluster, but if you would like to
set up a lightweight preview deployment, you can do so locally using using
[Docker](https://www.docker.com/) and [kind](https://kind.sigs.k8s.io/).

> Coder currently supports local preview only on workstations running macOS or
> Linux.

## Prerequisites

Before proceeding, please make sure that you have the following installed:

1. [Docker](https://hub.docker.com/search?q=docker&type=edition&offering=community)
2. [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
3. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)
4. [helm](https://helm.sh/docs/intro/install)

## Installing Coder

To install Coder, run:

```bash
curl -fsSL https://coder.com/try.sh | PORT="8080" sh
```

> Note: you can edit the value of `PORT` to control where the Coder
> dashboard will be available.

When the installation process completes, you'll see the URL and login
credentials you need to access Coder:

```txt
You can now access Coder at

    http://localhost:8080

You can tear down the deployment with

    kind delete cluster --name coder

Platform credentials
User:     admin
Password: yfu...yu2
```

Visit the URL, and log in using the provided credentials. Immediately after
logging in, Coder prompts you to set a permanent password.

## Removing Coder

To remove the local Coder deployment, run:

```bash
kind delete cluster --name coder
```

Because Coder runs inside Docker, you should have nothing left on your machine
after tear down.
