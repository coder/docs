---
title: "Google Container Registry"
description: Add the Google Container Registry to Coder.
---

Google Container Registry (GCR) uses different authorization methods, unlike the
generic `registry:2` image that requires a username and password. This article
will show you how to add GCR to Coder using a `_json_key` file.

## Adding a private GCR registry

Create a `_json_key` file with your authorization information:

1. In the [Google Cloud Console](https://console.cloud.google.com/), configure a
   service account for access to the GCR registry holding your images for use
   with Coder.
1. Create a
   [JSON key file](https://cloud.google.com/container-registry/docs/advanced-authentication#json-key).

Add your private GCR registry during the process of
[adding images](../../images/index.md). To import an image:

1. Go to **Images** > **Import Image** in the upper-right.
1. In the dialog that opens, you'll be prompted to pick a registry by default.
   However, to _add_ a registry, click **Add a new registry**, which is the
   option located immediately below the registry selector.
1. You'll be asked to provide a **registry name** and the **registry**. You can
   leave the **registry kind** as the default **Generic** value.
1. Since your registry is a **private registry**, provide the `_json_key` string
   for the **username** and the file's contents for **password**.
1. Continue with the process of [adding your image](../../images/index.md).
1. When done, click **Import**.
