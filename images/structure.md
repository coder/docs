# Structure

Coder allows your organization to structure your image hierarchy however you'd
like. However, we've seen organizations do well by defining a set of
organization-wide base images from which all projects are created.

These base images extend common open-source base images. They also contain
security patches, org-wide utilities, and configuration settings/information
that individual project images will get by default when you create additional
images. For example:

```dockerfile
FROM ubuntu:20.04

# Install baseline packages
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    build-essential \
    git \
    bash \
    curl \
    wget \
    unzip \
    htop \
    man \
    vim \
    sudo \
    python3 \
    python3-pip \
    ca-certificates \
    locales

# Add a user `coder` so that you're not developing as the `root` user
RUN adduser --gecos '' --disabled-password coder && \
  echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
USER coder
```

Your users can then create descendant images. These contain all of the original
tooling and configuration installed onto the base image and the new
customizations added by the users.

## Coder assets

Coder inserts static assets into each workspace, including:

- code-server
- JetBrains Projector
- Coder CLI, which includes the [Coder Agent](../setup/architecture.md)

These assets are installed into the `/var/tmp/coder` directory of each
workspace. You do not need to include these static assets in your custom images.
However, the following software are **required** when you build custom images:

- [POSIX Utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html)
- [GNU libc](https://www.gnu.org/software/libc/libc.html)
  - The minimum GNU libc version supported for the Coder-inserted assets is
    `2.1`
  - Coder doesn't support Alpine, since it uses musl libc
- [GNU Core Utilities](https://www.gnu.org/software/coreutils/)

The following utilities are **optional**:

- [ssh-agent](https://www.ssh.com/academy/ssh/agent) to automatically add the
  Coder user's public SSH key to the agent
- [systemd](https://systemd.io) for service supervision (this is only available
  with [CVMs](../workspaces/cvms)
- [OpenSSH](https://www.openssh.com) server
  - You can run OpenSSH from either your `coder/configure` script or `systemd`
