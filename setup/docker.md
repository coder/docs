---
title: "Coder for Docker"
description: Learn how to run Coder with Docker.
---

Coder for Docker allows you to deploy Coder to any machine on which Docker runs
quickly.

## Prerequisites

You must be using a machine that is running **macOS** and has
[Docker Desktop](https://www.docker.com/products/docker-desktop) installed.

## Getting started

1. Launch Docker Desktop.

1. In the terminal, run the following to download the resources you need,
   include the images, and set up your Coder deployment:

   ```console
   docker run -it --rm -p 7080:7080 -v ~/.coder:/var/run/coder -v /var/run/docker.sock:/var/run/docker.sock -e ENVBOX_IMAGE=kylecarbs/test-image-2:latest kylecarbs/test-image:0.4.0
   ```

   When this process is complete, Coder will print the URL you can use to access
   your deployment, as well as the admin credentials you'll need to log in. Make
   a note of these values, because you will need these in the subsequent step.

1. Launch a web browser and navigate to the URL provided by Coder (e.g.,
   `http://localhost:7080`). Log in using the credentials Coder provided.

1. At this point, you can [create a workspace](../workspaces/getting-started.md)
   using one of the **Packaged** images by clicking on **New workspace** in the
   center of the UI.

At this point, you're ready to use your workspace.

## Usage notes

When running, Docker Desktop displays both your Coder deployment and your
workspace.

![Docker Desktop view](../assets/setup/docker-desktop.png)

You can also view runtime information (i.e., API calls) in the console where you
started your deployment:

![Console realtime info](../assets/setup/coder-for-docker-console.png)
