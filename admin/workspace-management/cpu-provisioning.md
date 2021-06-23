---
title: CPU provisioning
description: Learn how to set the CPU provisioning
ratio.
---

Coder allows you to set the CPU provisioning ratio for each of your
organizations. The CPU provisioning ratio configures workspaces with a
guaranteed minimum capacity, while enabling them to use available capacity for
improved performance. The guaranteed minimum capacity is equivalent to the total
CPUs provisioned for a workspace divided by the provisioning ratio.

For example, let's say that you set a CPU provisioning ratio of 8:1. A workspace
with 4  virtual CPUs (vCPUs) would only have 0.5 physical CPUs reserved on the
underlying node. However, the workspace could use additional resources available
for more intensive processes (e.g., building or compiling code).

## Changing the CPU provisioning ratio

1. Go to **Manage** > **Organizations** and select your organization.
1. At the top of your organization page, click **Actions** > **Edit**. Scroll
   down to **CPU Provisioning Rate** and set the maximum ratio.
1. Click **Update**.

![Set CPU provisioning ratios](../../assets/admin/cpu-provisioning-ratios.png)
