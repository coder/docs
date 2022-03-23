---
title: Workspace provider provisioning via CLI
description: Learn how to provision a workspace provider using the Coder CLI.
---

1. Install and authenticate the Coder CLI.

1. Run the following to provision a new workspace provider (be sure to replace
   the placeholders as necessary):

   ```console
   coder providers create kubernetes [name] --namespace=[namespace] --cluster-address=[clusterAddress]
   ```

    <!-- markdownlint-disable -->

   | **Parameter**   | **Description**                                                                |
   | --------------- | ------------------------------------------------------------------------------ |
   | Name            | The name for the workspace provider you'd like provisioned                     |
   | Namespace       | Namespace in which to provision workspaces. |
   | Cluster address | The address of the Kubernetes control plane. Find using `kubectl cluster-info` |

    <!-- markdownlint-restore -->

   Example usage:

   ```console
   coder providers create kubernetes my-provider --namespace=my-namespace --cluster-address=https://255.255.255.255`
   ```

1. Once you've provisioned the workspace provider,
   [deploy it to the cluster](#coder-cli-and-workspace-providers).

   Ensure that you're connected to the cluster you're deploying to, and run the
   provided `helm upgrade` command; it should look something like the following,
   but with the placeholders filled with values appropriate to your deployment:

   helm upgrade coder-workspace-provider coder/workspace-provider \
    --version=<version> \
    --atomic \
    --install \
    --force \
    --set envproxy.token=<token> \
    --set envproxy.accessURL=<envproxyAccessURL> \
    --set ingress.host=<ingressHostName> \
    --set envproxy.clusterAddress=<clusterAddress> \
    --set cemanager.accessURL=<cemanagerAccessUrl>

   > WARNING: The 'envproxy.token' is a secret value that authenticates the
   > workspace provider; make sure that you don't share this token or make it
   > public.

   You can set
   [additional values of the Helm Chart](https://github.com/cdr/enterprise-helm/blob/workspace-providers-envproxy-only/README.md)
   to customize the deployment further.
