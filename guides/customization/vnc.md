---
title: Using VNC with Coder
description: Learn how to use a VNC with Coder
---

This guide will show you how to set up a Virtual Network Computing (VNC) system
in Coder. Coder does not have a specific set of VNC providers it supports. Coder
will render the VNC, as long as it is installed on the image used to create the
environment.

## Step 1: Create a Dockerfile image with a VNC provider installed

When creating the image, be sure to set the following variables:

```console
HOME=/home/coder
USER coder
PORT 1234
```

**Note:** Set `PORT` to the relevant port number for your VNC instance.

Here is an
[example image](https://github.com/cdr/enterprise-images/tree/ed66817dfa83e33132322c33bea653a8a5fdc057/images/vnc)
that uses [noVNC](https://github.com/novnc/noVNC) and
[TigerVNC](https://tigervnc.org).

## Step 2: Build and and push the image

Run the following commands to build the image and push it into Docker Hub:

```console
docker build . -t <yourusername>/vnc
docker push <yourusername>/vnc
```

## Step 3: Import image into Coder

a. Login in to Coder and navigate to **Images** and select **Import Image**

b. Import or select a registry and define the VNC image in the **Repository**
and **Tag** fields

c. Set the recommended resources for your VNC instance

b. Click **Import Image**

## Step 4: Create environment with VNC image

a. Navigate back to the environment dashboard, select **New Environment** and
choose **Custom Environment**

b. Give your environment a name and select your VNC image from the **Existing**
dropdown

c. Leave the [Container-based Virtual Machine (CVM)](../../environments/cvms.md)
option unchecked, as it does not support VNCs at this time

d. Click **Create Environment**

## Step 5: Create Dev URL and access the VNC

a. From the environment dashboard, click **Add URL**

b. Give it a name and specify the port number the VNC is running on, denoted in
the image.

c. Click the **Open in Browser** icon to access the VNC

You can now access the VNC in Coder.
