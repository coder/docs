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

2. Upgrade to the desired version (i.e., `1.16.0`):

    ```bash
    helm upgrade --namespace coder --force --install --atomic --wait \
      --version 1.16.0 coder coder/coder
    ```

## Troubleshooting

If the upgrade fails due to error messages such as a field is
immutable or helm doesn't control a resource, the best way to
remedy it is to `uninstall` and then reinstall.

Sample errors:

```
failed to replace object: Service "cemanager" is invalid: 
spec.clusterIP: Invalid value: "": field is immutable
```

```
Error: UPGRADE FAILED: rendered manifests contain a resource
that already exists. Unable to continue with update:
ServiceAccount "coder" in namespace "coder" exists and cannot
be imported into the current release: invalid ownership metadata;
label validation error: missing key
"app.kubernetes.io/managed-by": must be set to "Helm"; annotation
validation error: missing key "meta.helm.sh/release-name": must
be set to "coder"; annotation validation error: missing key
"meta.helm.sh/release-namespace": must be set to "coder"

```

1. Retrieve the helm running values into a file:

    ```bash
    helm get values --namespace coder coder > current-values.yml
    ```

2. Run helm uninstall:

    ```bash
    helm uninstall --namespace coder coder`
    ```

    Be sure not to use "delete" since that would remove
    the PVCs for the database. Uninstall and re-install
    will keep the persistent volume claim and reattach it.
    It may lose the IP address for the ingress controller
    so you may need to update your host and devurl IP
    addresses in your DNS provider.

    Also check the namespace for items slow to delete.
    Web-ingress took a bit of time to finish releasing
    the IP address so running the installation command
    failed since the service existed but was in a
    terminating state.

3. Run upgrade command with new version and values file:

    ```bash
    helm upgrade --namespace coder --atomic \
    --wait --install --force --version 1.16.0 \
    coder coder/coder -f current-values.yml
    ```
