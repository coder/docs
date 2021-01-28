---
title: "Updating"
description: Learn how to update your Coder deployment.
---

This guide will show you how to update your Coder deployment.

## Prerequisites

If you haven't already, install [helm](https://helm.sh/docs/intro/install/).

Before beginning the update process, please make sure that you've added the
Coder helm repo to your cluster. You can verify that the Coder repo has been
added to helm using `helm repo list`:

```bash
$ helm repo list
NAME URL
coder https://helm.coder.com
```

If you don't have the Coder repo, you can add it:

```bash
helm repo add coder https://helm.coder.com
```

Please also ensure that your Kubernetes config is pointing to the cluster on
which you've deployed Coder.

## Update Coder

Updating Coder is a two-step process:

1. Retrieve the latest repository information:

    ```bash
    helm repo update
    ```

2. Upgrade to the desired version (i.e., `1.15.2`):

    ```bash
    helm upgrade --namespace coder --force --install --atomic --wait \
      --version 1.15.2 coder coder/coder
    ```
