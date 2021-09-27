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

- Coder v1.21 introduces new networking features. To take advantage of these
  features, you must migrate your workspace providers individually after
  upgrading to v1.21; see [Upgrade steps for v1.21](#upgrading-to-v121) for more
  information.

## Update Coder

1. Retrieve the latest repository information:

   ```console
   helm repo update
   ```

1. Export your current Helm chart values into a file:

   ```console
   helm get values --namespace coder coder > current-values.yaml
   ```

   > Make sure that your values only contain the changes you want (e.g., if you
   > see references to a prior version, you may need to remove these).

1. Provide your Helm chart values file and upgrade to the desired version (e.g.,
   1.21.0):

   _Note: If you omit `--version`, you'll upgrade to the latest version._

   ```console
   helm upgrade --namespace coder --install --atomic --wait \
     --version <version> coder coder/coder --values current-values.yaml
   ```

1. Set Helm value `coderd.serviceNext=true` in your Helm chart. To do so, open
   up `current-values.yaml` and add the following:

   ```yaml
   coderd:
     serviceNext: true
   ```

1. Update Coder with your new Helm chart:

   ```console
   helm upgrade coder coder/coder -n coder --version=<VERSION> --values current-values.yaml
   ```

### Updating Coder when using a custom ingress controller

If you're using a custom ingress controller, the upgrade process from 1.20 to
1.21 requires a few more steps:

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
   1.21.0):

   _Note: If you omit `--version`, you'll upgrade to the latest version._

   ```console
   helm upgrade --namespace coder --install --atomic --wait \
     --version <version> coder coder/coder --values current-values.yaml

   ```

1. [Update your Helm chart](../guides/admin/helm-charts.md) via the steps below.
   Refer to the `1.21`
   [helm chart](https://github.com/cdr/enterprise-helm/blob/main/values.yaml)
   when making such changes:

   Rename all instances of `cemanager` to `coderd`.

   Redirect all traffic from your custom ingress to `coderd`.

   `coderd` now serves TLS certificates; to upgrade the NGINX ingress
   controller, set `coderd.serviceNext` to `true`. (See our
   [TLS certificates](../guides/tls-certificates/index.md) for more information
   on how to configure Coder to issue and use certificates.)

   > To manage SSH, go to **Manage** > **Providers**. Select the provider you
   > want to modify, click the **vertical ellipses** to its right, and click
   > **Edit**. Under **Features**, you can toggle **External Connect** on/off.
   >
   > To manage the Access URL, go to **Manage** > **Admin** >
   > **Infrastructure**.

1. Redirect traffic by updating the following ports:

   Move TCP port `8080` to `80`.

   Move TCP port `8443` to `443`.

1. Update Coder with your new Helm chart values:

   ```console
   helm upgrade coder coder/coder -n coder --version=<VERSION> --values current-values.yaml
   ```

1. Upgrade workspaces to use Coder's new Networking v2 functionality.

   If you're using only the built-in provider and don't have additional
   workspace providers, go to Manage > Providers. Find your provider, click the
   **vertical ellipses** to its right, and click **Edit**. Toggle **Networking
   v2** to enable.

   Alternatively, if your workspaces are distributed, migrate the providers to
   [satellites](../admin/satellites/index.md).

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

## Upgrading to v1.21

We introduced networking V2 (a.k.a. NetV2) in v1.21 as an optional operating
mode for [workspace providers](/docs/admin/workspace-providers). The following
steps walk you through upgrading from an earlier version of Coder to v1.21, then
from v1.21 to v1.22 (or later).

1. Upgrade the main Coder deployment to the most recent v1.21 patch (e.g.,
   `1.21.4`).

1. Upgrade your workspace providers (called
   [Satellites](../admin/satellites/index.md) in newer versions) to the same
   patch of 1.21.

1. Log in to Coder as a site admin or site manager. Go to **Manage** >
   **Workspace** Providers and enable **NetV2** for the **Built-in provider**.

1. Enable **NetV2** for each of your workspace providers. Validate that you can
   rebuild your workspaces.. You may need to update DNS or TLS configurations
   for your clusters.

1. After you've upgraded all of your workspace providers, enabled NetV2, and
   validated your changes, upgrade the main deployment to the latest v1.22
   patch.

1. Remove the workspace provider Helm chart. The final Coder version that uses
   the workspace provider Helm chart is v1.21; because the release disowns the
   service account from Helm, uninstalling the chart will not impact the
   workspace providers.

1. To re-establish the individual clusters as Coder satellites, upgrade Coder to
   the latest version and
   [follow the satellite installation steps](../admin/satellites/migration.md).
