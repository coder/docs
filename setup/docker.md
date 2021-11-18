---
title: "Coder for Docker"
description: Learn how to run Coder with Docker.
---

Coder for Docker allows you to deploy Coder to any machine on which Docker runs
quickly.

## Prerequisites

You must be using a machine that is running Linux/macOS and has
[Docker Desktop](https://www.docker.com/products/docker-desktop) installed.

## Installing Coder for Docker

1. Launch Docker Desktop.

1. If you've previously installed Coder, run `rm -rf ~/.coder` in the terminal.

1. In the terminal, run the following to download the resources you need,
   include the images, and set up your Coder deployment:

   ```console
   docker run --rm -it -p 7080:7080 -v /var/run/docker.sock:/var/run/docker.sock -v ~/.coder:/var/run/coder codercom/coder:1.25.0
   ```

   When this process is complete, Coder will print the URL you can use to access
   your deployment, as well as the admin credentials you'll need to log in:

   ```console
   > Welcome to Coder! 👋
   > Head to http://localhost:7080 to get started!

   > 🙋 Username: admin
   > 🔑 Password: 5h...7n
   ```

   Make a note of these values, because you will need these in the subsequent
   step.

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

## Dev URLs

To use a dev URL, set an environment variable when issuing the `docker run`
command to start your deployment (be sure to replace the placeholder URL):

```console
DEVURL_HOST="*.mycompany.com"
```

For example:

```console
docker run --rm -it -p 7080:7080 -v /var/run/docker.sock:/var/run/docker.sock -v ~/.coder:/var/run/coder codercom/coder:1.25.0 -e DEVURL_HOST="*.mycompany.com"
```

## Scaling

Coder for Docker is limited by the resources of the machine on which it runs. We
recommend using Kubernetes or AWS EC2 providers if you would like automatic
multi-machine scaling.

For organizations, we recommend one Docker host per team of 5-10 developers.

## Known issues

Currently, Coder for Docker does not support:

- External PostgreSQL databases
- The use of your own TLS certificates. If you'd like to use TLS with Coder for
  Docker, you'll need to run Coder behind a reverse proxy (e.g., Caddy or NGINX)
  and terminate TLS at that point.
