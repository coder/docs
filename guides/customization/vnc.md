---
title: Virtual Network Computing
description: Learn how to set up a VNC in Coder.
---

This guide will show you how to set up a virtual network computing (VNC) system
in Coder.

Coder does not have a specific set of VNC providers it supports. Coder will
render the VNC, as long as it is installed on the image used to create the
environment.

## Step 1: Create the Dockerfile

To begin, create a Dockerfile that you'll use to build an
[image](../../images/index.md) with a virtual network computing (VNC) provider
installed.

Be sure to set the `HOME`, `USER`, and `PORT` environment variables in the
Dockerfile:

```text
HOME=/home/coder
USER coder
PORT 1234
```

**Note:** Set `PORT` to the appropriate port number for your VNC instance.

> To help you get started, see this [sample Dockerfile](sample-dockerfile) that
> uses [noVNC](noVNC) as the client and [TigerVNC](TigerVNC) as the server.

[sample-dockerfile]:
  https://github.com/cdr/enterprise-images/tree/ed66817dfa83e33132322c33bea653a8a5fdc057/images/vnc
[novnc]: https://github.com/novnc/noVNC
[tigervnc]: https://tigervnc.org

## Step 2: Build and push the image to Docker Hub

Once you've created your image, build and push it to Docker Hub:

```console
docker build . -t <yourusername>/vnc
docker push <yourusername>/vnc
```

## Step 3: Import the image into Coder

Now that your image is available via Docker Hub, you can import it for use in
Coder.

1. Log in to Coder and go to **Images** > **Import Image**

1. Import or select a [registry](../../admin/registries/index.md).

1. Provide the **Repository** and **Tag** of the VNC image. Optionally, you can
   include a **Description** and the **Source Repo URL** that refers to the
   image's source.

1. Set the recommended resources (CPU cores, memory, disk space) for your VNC
   instance.

1. Click **Import Image**.

## Step 4: Create an environment with the image

Once you've imported your image into Coder, you can use it to create an
environment.

1. In the Coder UI, go to the **environment overview** page. Click **New
   Environment** and choose **Custom Environment**

1. Provide an **Environment Name**, and indicate that your **Image Source** is
   **Existing**.

1. Select your **Image** and associated **Tag**.

   > Make sure to leave the **Run as Container-based Virtual Machine** option
   > _unchecked_; this image doesn't currently include support for
   > [CVMs](../../environments/cvms.md).

1. Click **Create Environment**

## Step 5: Create a Dev URL and access the VNC

Now that you've created your environment, you'll need to create a
[dev URL](../../environments/devurls.md) so that you can access its services.

1. From the **environment overview** page, click **Add URL**

1. Provide the **Port** number that the VNC is running on (this information is
   defined in the image you used to build this environment).

1. Provide a **name** for the dev URL.

1. Click **Save**.

You can now access the VNC in Coder by clicking the **Open in Browser** icon
(this will launch a separate window).
