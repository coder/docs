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

> To help you get started, see this
> [sample image](https://github.com/cdr/enterprise-images/tree/main/images/vnc)
> that uses [noVNC](https://github.com/novnc/noVNC) as the client and
> [TigerVNC](https://tigervnc.org) as the server.

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

1. Click **Create Environment**

## Option 1: Connect via web

If your image includes [noVNC](https://github.com/novnc/noVNC), or another
web-based client, you can use a [dev URL](../../environments/devurls.md) to
access it securely.

1. From the **environment overview** page, click **Add URL**

1. Provide the **Port** number that noVNC is running on (this information is
   defined in the image you used to build this environment).

1. Provide a **name** for the dev URL.

1. Click **Save**.

You can now access the VNC in Coder by clicking the **Open in Browser** icon
(this will launch a separate window).

## Option 2: Connect with a local VNC Client

If your Coder deployment has [ssh](https://coder.com/docs/admin/environment-management/ssh-access)
enabled, you can also connect via a local client with SSH port forwarding.

You will need to install [coder-cli](https://github.com/cdr/coder-cli), and a
VNC client on your local machine.

Run the following commands on your local machine to connect to the VNC server.
Replace `[vnc-port]` with the port the server is running on and
`[workspace-name]` with the environment you created in step 4.

```console
# Ensure the workspace you created is an SSH targer
coder config-ssh

# Forward the remote VNC server to your local machine
ssh -L -N [vnc-port]:localhost:localhost:[vnc-port] coder.[workspace-name]
# You will not see an output if it succeeds

# Now, you can connect your VNC client to localhost:[vnc-port]
```
