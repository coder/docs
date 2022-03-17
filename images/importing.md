---
title: "Import"
description: "Learn how to import images to use in Coder."
---

Coder imports images from [Container Registries](../admin/registries/index.md).

> Images are associated with Coder Organizations which Users are Members of. 
> Any Organization Member can import an image but only the Organization Manager
> can link container registries to an Organization.

e.g., Java-team is an Organization. Sarah is an Organization Manager who links one or more container registries to Java-team. Mark and Becky are Organization Members and can import authorized images into the Java-team organization. This is how you control and govern which images can be used by developers.

To import an image:

1. Go to **Images > Import Image**.
1. Select the **registry** that hosts your image.
1. Provide your image's **repository** name and **tag**. Optionally, you can
   provide a **description** of the image (this is shown to all users) and a
   **Source Repo URL** to point to the image's source.
1. Specify the minimum amount of resources (cores, memory, and disk space) the
   workspace should have when using this image.
1. Click **Import Image**.


![Import image window](../assets/images/import-image.png)
