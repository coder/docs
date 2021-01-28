---
title: "Updating"
description: Learn how to update your Coder deployment.
---

This guide will show you how to update your Coder deployment.

## Dependencies

Install the following dependencies:

- [helm](https://helm.sh/docs/intro/install/)

Before beginning, please ensure that you've set up the Coder helm repo and that
your Kubernetes config is pointing to your Kubernetes cluster that Coder is
deployed into. You can verify that the Coder repo has been added to helm by
running helm repo list:

    ```bash
    $ helm repo list
    NAME URL
    coder https://helm.coder.com
    ```

If you don't have the Coder repo added, you can add it with the following:

    ```bash
    helm repo add coder https://helm.coder.com
    ```

## Update Coder

Updating Coder is a two-step process:

1. Retrieve the latest repository information:

    ```bash
    helm repo update
    ```

2. Upgrade to the specified version (ex: 1.15.2):

    ```bash
    helm upgrade --namespace coder --force --install --atomic --wait \
      --version 1.15.2 coder coder/coder
    ```
