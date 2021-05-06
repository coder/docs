---
title: Node.js Projects
description: Learn how to create custom images for Node.js projects.
---

This guide will show you how to create a Coder image for a
[sample blog project](https://github.com/gatsbyjs/gatsby-starter-blog) that's
written in Node.js.

The Coder [workspace](../../workspaces/index.md) that you'll create using this
image and be using for your project includes:

- The source code for the project, which is automatically cloned from GitHub
- The Node.js version that's compatible with this project, as well as several
  global dependencies obtained via npm
- Environment variables containing the developer API keys

## Requirements

- A Code deployment (you can request a [trial license](https://coder.com/trial);
  afterward, see our [installation guide](../../setup/installation.md))
- Docker (you can have this installed locally or on an existing Coder workspace)
- A Docker Hub account or access to another Docker registry
- VS Coder or the text editor of your choice

## Step 1: Create the Dockerfile

In Coder, developer workspaces are defined by a Dockerfile that contains the
apps, tools, and dependencies that you need to work on the project.

> See Docker’s
> [guide to writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
> for more information.

To create your Dockerfile, as well as the
[configure script](../../images/configure) that Coder runs automatically once it
has started your workspace:

Create a folder for the image you're creating:

```console
mkdir node_apps
```

We strongly recommend that you version control your Dockerfiles:

```console
cd node_apps
git init
```

Create a file named `configure` that runs when your workspace starts:

```console
touch node_apps/configure
chmod +x node_apps/configure
```

At this point, you can open your text editor and begin the Dockerfile for your
image. Coder maintains base images that contain the recommended software for a
Coder workspace. For this guide, we recommend that you use the Ubuntu one:

```Dockerfile
# Dockerfile

FROM codercom/enterprise-base:ubuntu

# Copy the configure script to /coder/configure where Coder can find it
COPY configure /coder/configure
```

## 2. Install Node.js and global dependencies

There are two options when it comes to installing Node.js and the global
dependencies that you'll need for this project.

### Option 1: Install Node.js directly from NodeSource

To include instructions for installing Node.js directly from
[NodeSource](https://github.com/nodesource/distributions#installation-instructions):

```Dockerfile
# Dockerfile

...

# Install Node.js 15
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# Install global packages
RUN npm install --global yarn@v1.22.5
```

### Option 2: Use nvm

If you'd like to use nvm instead of supporting multiple versions of Node.js in a
single workspace, you can do so using the `configure` script.

In the following example, you're _not_ installing `nvm` in the user's home
directory. As such, the image is the deciding factor for the Node.js version
that's installed and any global packages.

```Dockerfile
# Dockerfile
FROM codercom/enterprise-base:ubuntu

USER root

# Set NVM_DIR outside of the home directory so it doesn't persist across rebuilds
ENV NVM_DIR=/usr/bin/nvm
RUN mkdir -p $NVM_DIR
RUN chown coder:coder $NVM_DIR

# Install nvm as the "coder" user
USER coder
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    # Install any Node versions we need
    && nvm install 12.21.0 \
    && nvm install 15.12.0 \
    && nvm alias default 15.12.0 \
    && nvm use default \
    # Install global packages on the default version of node
    && npm install --global yarn@v1.22.5

# Copy configure script (we need this to add nvm to our path)
COPY configure /coder/configure
```

The `configure` script is as follows:

```sh
# configure

#!/bin/bash

# if nvm command fails, try to add it to our profile and PATH
if ! command -v nvm &> /dev/null
then
    echo "nvm command not found... attempting to add to your profile via the install script"

    # Create a .bash_profile file if it doesn’t exist
    touch ~/.bash_profile

    # run the install script to add to profile
    $NVM_DIR/install.sh

    export NVM_DIR="/usr/bin/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
```

> We have recently released **configure steps** in workspace templates. See
> <https://github.com/bpmct/company-blog> to see how you can implement this new
> functionality.

## Step 3: Clone projects automatically

In the `configure` script, you can set `git clone` to run on your behalf
(assuming that you've
[linked your Git account](/../../../workspaces/preferences.md#linked-accounts)).
We recommend using the SSH option.

In your `configure` script, include:

```sh
# configure

# 1. Ensure that you've added GitHub's host key to known_hosts
if ! grep github.com ~/.ssh/known_hosts > /dev/null; then
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2> /dev/null
fi

# 2. Clone your project
GIT_REMOTE="git@github.com:bpmct/company-blog.git"
CLONE_TO="$HOME/company-blog"

if [ ! -d $CLONE_TO ]; then
  echo "$CLONE_TO is empty... Cloning"
  git clone $GIT_REMOTE $CLONE_TO/.
else
  echo "$CLONE_TO exists ✅"
fi
```

If you have multiple repositories, you can clone each one by replicating and
including the cloning instructions shown above.

## Step 4: Add environment variables

There are two ways to add environment variables so that they're available to
anyone who uses the image.

### Option 1: Specify environment variables in the Dockerfile

> Note: If you have secret credentials, make sure you make the image private in
> the Docker Hub, or use a private registry!

```Dockerfile
# Dockerfile

...

ENV PORT=3000

ENV API_KEY=asdfjkl
```

### Option 2: Add a secrets manager to the Coder image

You can install a secrets manager in Coder just as you would with a local
machine. This approach is more secure than the option mentioned previously,
since it doesn't require you to commit sensitive information. However, you'll
still need to create an account with a secrets manager provider or host the
service of your choice.

Some options that you can consider include:

- [Doppler](https://docs.doppler.com/docs/enclave-installation-docker#option-1-dockerfile)
- [SecretHub.io](https://secrethub.io/docs/reference/cli/install/#linux)
- [Hashicorp Vault](https://learn.hashicorp.com/tutorials/vault/getting-started-install#install-vault)

## Step 5: Build and push your image

Once you've created your image, you can build and push it to your registry so
that it can be accessed by Coder and used to build your workspace. For this
guide, we'll show you how to do this with Docker Registry using the console, but
you can use the registry of your choice:

Log in to Docker Hub:

```console
docker login
```

Build the image (from the current directory) and tag it:

```console
docker build . -t [username]/gatsby-blog
```

Push the image:

```console
# Note: if you want this image to be private, make sure that
# you create the private image in hub.docker.com or use a
# private registry

docker push [username]/gatsby-blog
```

> We recommend adding CI-related steps to your git repository so that you can
> build images automatically and source control images. You can do this with
> GitHub Actions, GitLab, CircleCI, or even Docker Hub.

## Step 6: Import the image to Coder and create the workspace

At this point, you can [import your image](../../images/importing.md) and use it
to [create a new workspace](../../workspaces/getting-started.md). When you've
completed these steps, you can launch your workspace, which contains all of the
required tools and dependencies.

> See our [sample repo](https://github.com/bpmct/company-blog) for the example
> project and image configured for Coder.
