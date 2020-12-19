---
title: "Registries"
---

Coder hooks into public and private Docker Registries to pull images and manage
image metadata.

> You must be a **site manager** to add a registry or remove registries that
> aren't in use.

## Adding a Registry

You can add registries during the process of [adding
images](../../images/index.md).

To import an image, go to **Images** > **Import Image** in the upper-right. In
the dialog that opens, you'll be prompted to pick a registry by default.
However, to *add* a registry, click **Add a new registry**, which is the option
located immediately below the registry selector.

You'll be asked to provide:

- A **registry name**
- The **registry**
- A **username** and **password** combination (if needed for access to the
  registry)

Then, continue with the process of [adding your
image](../../images/index.md). When done, click **Import**.

## Deleting a Registry

> You cannot delete a registry if there are environments using images from that
> registry.

To delete a registry, go to the **Images** > **Registries** page. Find the
registry that you'd like to remove, click its **horizontal ellipses** icon, and
select **Delete**.
