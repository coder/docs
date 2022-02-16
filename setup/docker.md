---
title: "Coder for Docker"
description: Learn how to run Coder with Docker.
---

Coder for Docker allows you to deploy Coder to any machine on which Docker runs
quickly.

## Prerequisites

Coder for Docker works with the following platforms:

- macOS 10.10+ with
  [Docker Desktop 20.10](https://www.docker.com/products/docker-desktop)
- Ubuntu Linux 20.04 (Focal Fossa) with Docker Community Edition 20.10
- Windows 11 with
  [Docker Desktop 20.10](https://www.docker.com/products/docker-desktop).
  **Note**: Coder for Docker requires Windows Subsystem for Linux at this time.

At this time, Coder publishes builds for the x86-64 architecture only, and does
not support support Arm-based processors, such as those present in Apple Silicon
(M1) laptops or Amazon Graviton instances.

On Apple Silicon laptops, we have had some success using [Rosetta 2] to emulate
the x86-64 instruction set. To install Rosetta 2 on your macOS computer, run the
following command in a terminal window:

```console
softwareupdate --install-rosetta
```

[rosetta 2]: https://support.apple.com/en-us/HT211861

## Installing Coder for Docker

1. Launch Docker Desktop.

1. If you've previously installed Coder, run `sudo rm -rf ~/.coder` in the
   terminal.

1. In the terminal, run the following to download the resources you need,
   include the images, and set up your Coder deployment (if you're using the
   terminal in Docker Desktop, omit the slashes and run as a single-line
   command):

   ```console
   docker run --rm -it \
      -p 7080:7080 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v ~/.coder:/var/run/coder \
      codercom/coder:1.28.0
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

1. At this point, you can [create a workspace](../workspaces/create.md) using
   one of the **Packaged** images by clicking on **New workspace** in the center
   of the UI.

At this point, you're ready to use your workspace. See our
[getting started guide](../getting-started/docker.md) for detailed instructions
on getting your first workspace up and running.

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
docker run --rm -it -p 7080:7080 -v /var/run/docker.sock:/var/run/docker.sock -v ~/.coder:/var/run/coder -e DEVURL_HOST="*.mycompany.com" codercom/coder:1.27.0
```

## Use an external PostgreSQL database

If you'd like to use an external database, you must:

1. Disable the embedded database by setting the `DB_EMBEDDED` environment
   variable (see the next code snippet for an example)
1. Provide the connection information to the external PostgreSQL database:

   ```console
   docker run --rm -it -p 7080:7080 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v ~/.coder:/var/run/coder \
      # Disable using the embedded DB
      -e DB_EMBEDDED="" \
      # Change these values to match those for your database
      -e DB_HOST=127.0.0.1 \
      -e DB_PORT=5432 \
      -e DB_USER=postgres \
      -e DB_PASSWORD="" \
      -e DB_NAME=postgres \
      -e DB_SSL_MODE=disable \
      codercom/coder:1.27.0
   ```

Coder supports client TLS certificates using `DB_SSL_MODE=verify-full`. Ensure
that you mount the certs into the container (and add the flag
`-v <local_certs>:/certs`). Then, specify the certificate path using environment
variables:

<!-- markdownlint-disable -->

| **Flag/environment variable**     | **Description**                              |
| --------------------------------- | -------------------------------------------- |
| `-e DB_CERT=/certs/client.crt`    | The path to the client cert signed by the CA |
| `-e DB_KEY=/certs/client.key`     | The path to the client secret                |
| `-e DB_ROOT_CERT=/certs/myCA.crt` | The path to the trusted CA cert              |

<!-- markdownlint-enable -->

## Admin password

If you want to set (or reset) your admin password, use the
`-e SUPER_ADMIN_PASSWORD=<password>` flag with the `docker run` command.

## Scaling

Coder for Docker is limited by the resources of the machine on which it runs. We
recommend using Kubernetes or AWS EC2 providers if you would like automatic
multi-machine scaling.

For organizations, we recommend one Docker host per team of 5-10 developers.

## Known issues

Currently, Coder for Docker does not support:

- The use of your own TLS certificates. If you'd like to use TLS with Coder for
  Docker, you'll need to run Coder behind a reverse proxy (e.g., Caddy or NGINX)
  and terminate TLS at that point. See
  [our guide](../guides/tls-certificates/docker-tls.md) for information.
- Air-gapped deployments/offline installs
