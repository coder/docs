---
title: "Deprecate"
description: Learn how to deprecate an image.
---

You can mark images as deprecated to prevent them from being used to create new
environments.

1. Go to **Images** and find the image to mark as deprecated.
1. Click **Edit**.
1. Select the **Deprecate this image** checkbox.
1. Click **Update Image** to save your changes.

![Deprecating an Image](../assets/deprecate-image.png)

> Users cannot create new environments using deprecated images. However, they
> can continue to use _existing_ environments created with the now-deprecated
> images and edit the resources allocated to that environment.
