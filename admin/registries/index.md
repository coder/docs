---
title: "Registries"
description: Learn how to hook into Docker Registries.
---

Coder hooks into public and private Docker Registries to pull images and manage
image metadata.

> You must be a **site manager** to add a registry or remove registries that
> aren't in use.

## Adding a registry

You can add registries during the process of
[adding images](../../images/index.md).

To import an image:

1. Go to **Images** > **Import Image** in the upper-right.
1. In the dialog that opens, you'll be prompted to pick a registry by default.
   However, to _add_ a registry, click **Add a new registry**, which is the
   option located immediately below the registry selector.
1. You'll be asked to provide a **registry name** and the **registry**.
1. **Optional.** If your registry is a **private registry**, provide the
   **username** and **password** combination required to access the registry.
1. Then, continue with the process of [adding your
   image](../../images/index.md).
1. When done, click **Import**.

## Deleting a registry

> You cannot delete a registry if there are workspaces using images from that
> registry.

To delete a registry:

1. Go to the **Images** > **Registries** page.
1. Find the registry that you'd like to remove, click its **horizontal
   ellipsis** icon, and select **Delete**.

## Unsupported registries

Coder does not support the following registries at this time:

- Amazon ECR
- GitHub Packages
