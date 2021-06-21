---
title: "GPU acceleration"
description: Learn how to use GPUs with workspaces.
---

GPUs can be used for performing tasks such as machine learning within
workspaces.

By default, users cannot create workspaces with GPUs until a site manager
configures and enables this feature.

### Step 1: Configure your Kubernetes cluster

<a href="https://kubernetes.io/docs/tasks/manage-gpus/scheduling-gpus/"
target="_blank" rel="noreferrer noopener">Configure</a> your Kubernetes cluster
with the available GPUs and all necessary device plugins and drivers.

### Step 2: Enable GPU vendor in Coder

Go to **Manage** > **Admin**. On the **Infrastructure** tab, find the **GPU
Vendor** setting, and change it to the GPU vendor of choice (either **AMD** or
**Nvidia**). Click **Save Vendor**.

![Enable GPU vendor](../../assets/admin/gpu.png)
