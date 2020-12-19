---
title: "Structure"
description: Learn how to best structure Image specifications for use inside your organization.
---

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
