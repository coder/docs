---
title: Workspace provider provisioning via CLI
description: Learn how to provision a workspace provider using the Coder CLI.
---

1. Install and authenticate the Coder CLI.

1. Run the following to provision a new **Kubernetes** workspace provider (be
   sure to replace the placeholders as necessary):

   ```console
   coder providers create kubernetes [name] --namespace=[namespace] --cluster-address=[clusterAddress]
   ```

    <!-- markdownlint-disable -->

   | **Parameter**     | **Description**                                                                |
   | ----------------- | ------------------------------------------------------------------------------ |
   | `name`            | The name for the workspace provider you'd like provisioned                     |
   | `namespace`       | The namespace in which to provision workspaces.                                |
   | `cluster-address` | The address of the Kubernetes control plane; find using `kubectl cluster-info` |

    <!-- markdownlint-restore -->

   Example usage:

   ```console
   coder providers create kubernetes my-provider --namespace=my-namespace --cluster-address=https://255.255.255.255`
   ```

   To create a new **EC2** workspace provider:

   ```console
   coder providers create ec2 [name] --access-key-id=[access-key-id] --secret-access-key=[secret-access-key]
   ```

   <!-- markdownlint-disable -->

   | **Parameter**       | **Description**                                            |
   | ------------------- | ---------------------------------------------------------- |
   | `name`              | The name for the workspace provider you'd like provisioned |
   | `access-key-id`     | The AWS access key associated with your account.           |
   | `secret-access-key` | The AWS region where the EC2 instances should be created.  |

    <!-- markdownlint-restore -->

   ```console
   coder providers create ec2 my-provider --access-key-id=AKIAIOSFODNN7EXAMPLE --secret-access-key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
   ```

1. Once you've provisioned the workspace provider, deploy it to your
   [Kubernetes](../../admin/workspace-providers/deployment/kubernetes.md) or
   [EC2](../../admin/workspace-providers/deployment/ec2.md) cluster.

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
