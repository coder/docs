---
title: "Updating"
description: Learn how to update your Coder deployment.
---

This guide will show you how to update your Coder deployment.

## Prerequisites

- If you haven't already, install [Helm](https://helm.sh/docs/intro/install/).

- Before beginning the update process, ensure that you've added the Coder Helm
  repo to your cluster. You can verify that the Coder repo has been added to
  Helm using `helm repo list`:

  ```console
  $ helm repo list
  NAME URL
  coder https://helm.coder.com
  ```

  If you don't have the Coder repo, you can add it:

  ```console
  helm repo add coder https://helm.coder.com
  ```

- Ensure that you have superuser privileges to your PostgreSQL database.

## Recommendations

- As with any significant maintenance operation, we **strongly recommend**
  taking a snapshot of the database before proceeding with the upgrade. In the
  event that there are upgrade issues, it is simpler and safer to roll back
  directly at the database level, since it guarantees restoration of the system
  to a known working condition.

- We recommend updating no more than one major version at a time (i.e., we
  recommend moving from 1.15 to 1.16 only).

## Update Coder

To update Coder, follow these steps:

1. Retrieve the latest repository information:

   ```console
   helm repo update
   ```

1. Export your current Helm chart values into a file:

   ```console
   helm get values --namespace coder coder > current-values.yaml
   ```

   > Make sure that your values only contain the changes you want (i.e., if you
   > see references to a prior version, you may need to remove these).

1. Provide your Helm chart values file and upgrade to the desired version (e.g.,
   1.16.1):

   _Note: If you omit `--version`, you'll upgrade to the latest version._

   ```console
   helm upgrade --namespace coder --install --atomic --wait \
     --version 1.16.1 coder coder/coder --values current-values.yaml
   ```

## Fixing a failed upgrade

While upgrading, the process may fail. You'll see an error message similar to
the following samples indicating that a field is immutable or that Helm doesn't
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

1. Export the Helm chart values into a file:

   ```console
   helm get values --namespace coder coder > current-values.yaml
   ```

   > Double-check your values file to ensure it only contains your changes.

1. Run `helm uninstall`. This will uninstall all Coder-related services on the
   cluster (though it preserves the namespaces). It will not delete user
   workspaces or their associated volumes.

   > `helm uninstall` will delete the timescale instance internal to the cluster
   > but _not_ its associated volume, so all data will remain intact. If you're
   > using an external PostgreSQL database, this will not be affected.

   ```console
   helm uninstall --namespace coder coder
   ```

   Make sure to check the namespace for items that are slow to delete. For
   example **web-ingress** can take some time to release the IP addresses; if
   you run the install command before this process completes, the install
   process will fail.

   Running `uninstall` removes the `web-ingress` service that owns the ingress
   controller's IP address. As such, the `web-ingress` service may have a new
   public IP address or hostname after you reinstall; if this is the case,
   update your DNS provider with your new IP and CNAME.

1. Run the `upgrade` command with the new version number and Helm chart values
   file:

   ```console
   helm upgrade --namespace coder --atomic \
   --wait --install --version 1.16.1 \
   coder coder/coder --values current-values.yaml
   ```

   The ingress may attach to a new public IP address; if this happens, you must
   update the host and Dev URL IP addresses with your DNS provider.
