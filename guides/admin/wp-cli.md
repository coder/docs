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

   > Run `coder providers create <provider> --help` for a full list of options
   > available.

1. Once you've provisioned the workspace provider, deploy it to your
   [Kubernetes](../../admin/workspace-providers/deployment/kubernetes.md) or
   [EC2](../../admin/workspace-providers/deployment/ec2.md) cluster.
