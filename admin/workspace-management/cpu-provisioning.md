---
title: CPU provisioning
description: Learn how to provision more workspaces on a single node
---

Coder allows you to set CPU provisioning ratios for each of your organizations. By
changing this ratio, you can schedule more virtual CPUs requested by the workspaces
onto a single node CPU.

For example, with a CPU provisioning ratio of 8:1, a workspace with 4 vCPUs would
only have 0.5 physical CPUs reserved on the underlying node. This results in cost
savings as compute resources are conserved for less compute-intensive operations,
and reserved for more bursty workloads, such as building and compiling code.

## Changing the CPU provisioning rate

1. Go to **Manage** > **Organizations** and select your organization.
1. At the top of your organization page, click **Actions** > **Edit**. Scroll
   down to **CPU Provisioning Rate** and set the maximum ratio
1. Click **Update**.

![Set memory overprovisioning ratios](../../assets/admin/set-memory-ratios.png)
