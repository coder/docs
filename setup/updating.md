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

To update Coder, follow these steps:

1. Retrieve the latest repository information:

    ```bash
    helm repo update
    ```

1. (Optional) Export the current helm chart values into a file:

    ```bash
    helm get values --namespace coder coder > current-values.yml
    ```

1. Upgrade to the desired version with your helm chart values file (i.e., `1.16.1`):

    _Note: Omitting `--version` will default to the latest version_

    ```bash
    helm upgrade --namespace coder --force --install --atomic --wait \
      --version 1.16.1 coder coder/coder --values current-values.yml
    ```

## Fixing a Failed Upgrade

While upgrading, the process may fail. You'll see an error message similar to
the following samples indicating that a field is immutable or that helm doesn't
control a resource:

```text
failed to replace object: Service "cemanager" is invalid: 
spec.clusterIP: Invalid value: "": field is immutable
```

```text
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

If this happens, we recommend uninstalling and reinstalling:

1. Export the helm chart values into a file:

    ```bash
    helm get values --namespace coder coder > current-values.yml
    ```

1. Run `helm uninstall`:

    ```bash
    helm uninstall --namespace coder coder
    ```

    **Do not use `delete`** since this command removes the persistent volume
    claim (PVCs) for the database. Running `uninstall` then reinstalling will
    keep the PVCs and reattach them. You may, however, lose the IP address for
    the ingress controller; if that's the case, update your host and Dev URL IP
    addresses with your DNS provider.

    Make sure to check the namespace for items that are slow to delete. For
    example **web-ingress** can take some time to release the IP addresses; if
    you run the install command before this process completes, the install
    process will fail.

1. Run the `upgrade` command with the new version number and helm chart values
   file:

    ```bash
    helm upgrade --namespace coder --atomic \
    --wait --install --force --version 1.16.1 \
    coder coder/coder --values current-values.yml
    ```

    The ingress may attach to a new public IP address; if this happens, you must
    update the host and Dev URL IP addresses with your DNS provider.
