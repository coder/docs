---
title: NodeJS Projects in Coder
description: Learn how to create custom images for NodeJS Projects.
---

This guide covers how to build a Coder image for a
[sample blog project](https://github.com/gatsbyjs/gatsby-starter-blog), written
in NodeJS. The Coder workspace will include:

- The source code for the project (auto-cloned from git)
- A specific version of NodeJS, compatible with this project - Global npm
  packages
- Environment variables containing developer API keys

## Requirements

- Coder deployment [(get a trial license)](https://coder.com/trial)
- Docker (installed on your local machine or an existing Coder workspace)
- Docker Hub account (or access to another registry)
- VS Code or another text editor

## 1. Create the Dockerfile

In Coder, developer workspaces are defined by a Dockerfile that can contain the
software and dependencies needed for development. Check out Docker’s
[guide to writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
for more information.

Let's create the Dockerfile, as well as a
[configure script](../../images/configure) that will run once the workspace has
started:

```sh
# create a folder for the image we’re creating
$ mkdir node_apps

# we recommend version controlling your Dockerfiles
$ git init

# create a “configure file” that runs on workspace start
$ touch node_apps/configure
$ chmod +x node_apps/configure
```

We maintain two “base images” that contain a lot of the recommended software in
a Coder workspace. In this guide, we’ll use the Ubuntu one:

```Dockerfile
# Dockerfile

FROM codercom/enterprise-base:ubuntu

# copy the configure script to /coder/configure where it is run by Coder
COPY configure /coder/configure
```

## 2. Install NodeJS and global dependencies

### Option 1: Install NodeJS directly [NodeSource](https://github.com/nodesource/distributions#installation-instructions)

```Dockerfile
# Dockerfile

...

# Install NodeJS 15
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# Install global packages
RUN npm install --global yarn@v1.22.5
```

### Option 2: Use nvm

If you want to use nvm instead to support multiple versions of Node in a single
workspace, this can be done in the `configure` script.

In this example, we are not installing nvm in the user’s home directory so that
the image still controls the version(s) of node installed and any global
packages. See this image for an example of nvm being installed in the user’s
home directory.

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

```sh
# configure

#!/bin/bash

# if nvm command fails, try to add it to our profile and PATH
if ! command -v nvm &> /dev/null
then
    echo "nvm command not found... attempting to add to your profile via the install script"

    # Create a .profile file if it doesn’t exist
    touch ~/.profile

    # run the install script to add to profile
    $NVM_DIR/install.sh

    export NVM_DIR="/usr/bin/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    exit
fi
```

> We have recently released "configure steps," in workspace templates. See
> <https://github.com/bpmct/company-blog> to see how it is implemented with this
> new functioanlity.

## 3. Automatically clone our projects

In the configure script, we can `git clone` on behalf of the developer, assuming
they have linked their git account in Coder's settings. We recommend using the
SSH path here since Coder workspaces can clone on behalf of SSh.

This is done in our configure script:

```sh
# configure

# 1. ensure we have GitHub's host key added to known_hosts
if ! ssh-keygen -F github.com > /dev/null; then
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2> /dev/null
fi

# 2. clone our project
GIT_REMOTE="git@github.com:bpmct/company-blog.git"
CLONE_TO="$HOME/company-blog"

if [ ! -d $CLONE_TO ]; then
  echo "$CLONE_TO is empty... Cloning"
  git clone $GIT_REMOTE $CLONE_TO/.
else
  echo "$CLONE_TO exists ✅"
fi
```

If you have multiple repositories, you can replicate part two multiple times in
the script to clone each repository.

## 4. Add environment variables

There are two ways to add environment variables for everyone using the image.

Option 1: Specify environment variables for your projects in the Dockerfile.

> Note: If you have secret credentials, make sure you make the image private in
> the Docker Hub, or use a private registry!

```Dockerfile
# Dockerfile

...

ENV PORT=3000

ENV API_KEY=asdfjkl
```

Option 2: Add a secrets manager to the Coder Image

You can install an industry-standard secrets manager inside of Coder, just as
you would on a local machine. This approach is more secure, as it doesn’t
require you to commit sensitive information, but you’ll need to create an
account or host one of these services yourself.

For instructions on adding these tools to your Dockerfiles, see these guides:

- [Doppler](https://docs.doppler.com/docs/enclave-installation-docker#option-1-dockerfile)
- [SecretHub.io](https://secrethub.io/docs/reference/cli/install/#linux)
- [Hashicorp Vault](https://learn.hashicorp.com/tutorials/vault/getting-started-install#install-vault)

## 5. Build and push your image

You can now build and push your image to use in Coder! We’ll be using Docker
Hub, but you can use any registry.

```sh
# log in to Docker Hub
docker login

# build the image (from the current directory) and tag it
docker build . -t [username]/gatsby-blog

# push the image
# note: if you want this image to be private,
# make sure you create the private image in hub.docker.com
# or use another private registry
docker push [username]/gatsby-blog
```

We recommend you add CI to your git repository so that you can build images
automatically and source control your image. This can be done with GitHub
Actions, GitLab, CircleCi, or even Docker Hub itself.

## 6. Add the image to Coder and launch workspace

You can now launch your workspace containing all of the required tools and
dependencies.

Check out [the example repository](https://github.com/bpmct/company-blog) to see
an example project, and the image configured for Coder.

---

This guide is maintained by [Ben Potter](https://twitter.com/bpmct). If you have
questions, feel free to
[ask on our Slack channel](https://cdr.co/join-community).
