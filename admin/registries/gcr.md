---
title: "GCR"
description: Add the Google Container Registry to Coder.
---

Cloud container registries have different methods for authorization than the
generic `registry:2` image, which has a simple username and password.

[Google's Container Registry (GCR) has a few methods for 
authentication](https://cloud.google.com/container-registry/docs/advanced-authentication) 
which include a short-lived token, a credential helper, or a `_json_key` file.

## Adding a private GCR registry

You can add registries during the process of
[adding images](../../images/index.md).

To import an image:

1. Go to **Images** > **Import Image** in the upper-right.
1. In the dialog that opens, you'll be prompted to pick a registry by default.
   However, to _add_ a registry, click **Add a new registry**, which is the
   option located immediately below the registry selector.
1. You'll be asked to provide a **registry name** and the **registry**.
1. In the Google Cloud Console, configure a service account for access to
   the GCR registry for Coder's images.
1. Create a [JSON key file](https://cloud.google.com/container-registry/docs/advanced-authentication#json-key)
   by following the documented instructions.
3. Since your registry is a **private registry**, provide the string `_json_key`
   for the **username** and the contents of the file for **password**.
1. Continue with the process of [adding your image](../../images/index.md).
1. When done, click **Import**.
