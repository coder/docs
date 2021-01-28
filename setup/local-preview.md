---
title: "Local Preview"
description: Setup a Coder deployment locally for testing.
---

Coder is normally deployed onto Kubernetes clusters, but that can be overkill
for simply previewing the platform. To solve this, Coder provides a script to
test out the platform locally using [Docker](https://www.docker.com/) and
[kind](https://kind.sigs.k8s.io/)!

Since it runs everything inside Docker, teardown is super simple and nothing is
left on your machine.

Local preview currently only supports Mac and Linux.

## Installing

In a Mac or Linux environment, ensure that the following tools are installed:

1. `kubectl`: [https://kubernetes.io/docs/tasks/tools/install-kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)
1. `helm`: [https://helm.sh/docs/intro/install](https://helm.sh/docs/intro/install)
1. `kind`: [https://kind.sigs.k8s.io/docs/user/quick-start/#installation](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

Then, use the following script to install Coder:

```bash
curl -fsSL https://coder.com/try.sh | PORT="8080" sh
```

> Note: you can edit the `PORT` variable to control which local port the
> dashboard will be available on.

After the install completes, it will print out the URL and credentials to
login.

```txt
You can now access Coder at

    http://localhost:8080

You can tear down the deployment with

    kind delete cluster --name coder

Platform credentials
User:     admin
Password: yfuyjsuxtyu2
```

Visit the provided URL and login using the credentials. After this you'll be
prompted to set a permanent password.

## Tearing Down

To remove the local Coder deployment, run:

```bash
kind delete cluster --name coder
```
