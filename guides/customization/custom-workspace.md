---
title: Custom workspaces
description: Learn how to create a custom workspace.
---

This tutorial shows you how to create a customized, preconfigured development
workspace by walking you through setting up a web development workspace using
[Node.js](https://nodejs.org/) and [React.js](https://reactjs.org/).

## Prerequisites

Make sure that you've:

- Installed and configured [Docker](https://docs.docker.com/get-docker/) or the
  alternative image building utility (like
  [buildah](https://github.com/containers/buildah/blob/master/README.md)) of
  your choice
- Given your image building tool the rights needed to push to a
  [Docker Registry](https://docs.docker.com/registry/introduction/) (e.g.,
  [Docker Hub](https://hub.docker.com/))
- (Optional) Configured [dev URLs](../../admin/devurls.md) for your deployment

Your Coder user account must have permissions to
[import an image](../../images/importing.md).

## Step 1: Create a development image

A Coder development image should include all programming languages, development
utilities, testing frameworks, source control utilities, and other dependencies
that a developer needs to start contributing to a project immediately.

Since all of the Coder development workspaces are created on your Kubernetes
cluster, you can use
[Docker images](https://docs.docker.com/get-started/overview/#docker-objects) to
define your development images.

To demonstrate, we'll create a development image that utilizes
[Ubuntu](https://ubuntu.com/) as the base Operating System. We'll also install:

- [Node.js](https://nodejs.org/) to run the application
- [Yarn](https://yarnpkg.com/) for package management
- [WebStorm](https://www.jetbrains.com/webstorm/), an IDE designed for
  JavaScript development
- Additional utilities, including [git](https://git-scm.com/),
  [curl](https://curl.haxx.se/), and [bash](https://www.gnu.org/software/bash/)
  to make our workspace more developer-friendly

We have a copy of this image
[built and pushed](https://hub.docker.com/r/coderenterprise/react) to our Docker
Hub repository. You can use this and skip to **Step 3: Create the dev
workspace** if you don't want to build and push your image.

However, if you want to see how the image is made, please continue with the
following section.

### 1a. Defining your dockerfile

Each development image is defined through a
[Dockerfile](https://docs.docker.com/engine/reference/builder/). This file can
be source controlled along with your project's source code. Other developers
working on the project can see how the workspace was created or add additional
development dependencies as needed.

```dockerfile
FROM ubuntu:20.04

# Update the OS packages and install developer-friendly
# utilities needed in your dev workspace

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  # Development utilities
  git \
  bash \
  curl \
  htop \
  man \
  vim \
  ssh \
  sudo \
  lsb-release \
  ca-certificates \
  locales \
  gnupg \

  # Packages required for multi-editor support
  libxtst6 \
  libxrender1 \
  libfontconfig1 \
  libxi6 \
  libgtk-3-0

# Install the desired Node.js version into `/usr/local/`
ENV NODE_VERSION=12.16.3
RUN curl \
https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
 | tar xzfv - \
  --exclude CHANGELOG.md \
  --exclude LICENSE \
  --exclude README.md \
  --strip-components 1 -C /usr/local/

# Install the Yarn package manager
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Install WebStorm
RUN mkdir -p /opt/webstorm
ENV WEBSTORM_VERSION=2020.1.1
RUN curl \
-L https://download.jetbrains.com/webstorm/WebStorm-${WEBSTORM_VERSION}.tar.gz \
| tar -C /opt/webstorm --strip-components 1 -xzvf -

# Add a binary to the PATH that points to the WebStorm startup script
RUN ln -s /opt/webstorm/bin/webstorm.sh /usr/bin/webstorm

# Add a user `coder` so that you're not developing as the `root` user
RUN adduser --gecos '' --disabled-password coder && \
  echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
USER coder
```

### 1b. Build and push your image

At this point, you'll need to build the development image and push it to the
Docker registry. To do so, run the following command in the directory where your
Dockerfile is located (be sure to replace the placeholder values with your tag
and repository name so that the image is pushed to the appropriate location):

```console
docker build -t coderenterprise/react .
```

```console
docker push coderenterprise/react
```

## Step 2: Import the image

After you've pushed the image to a Docker registry, you can access and import it
into your Coder deployment.

1. In the Coder UI, go to the **Images** page and click **Import Image**
1. Add (or select) the image registry where the image is hosted, and provide the
   requested values when prompted.

## Step 3: Create the dev workspace

Once you've imported an image into Coder, you can use it to create new
development workspaces:

1. In the Coder UI, go to **Workspaces Overview**
1. Click **New Workspace**
1. In the modal window that opens, provide a **name** for your workspace, select
   the **image** that you imported, adjust the resources appropriately (if you
   plan to use WebStorm, allocate additional CPU and RAM), and click **Create**

The workspace will take a few minutes to build the first time due to the initial
image pulling but should take around 30-90 seconds on subsequent rebuilds and
updates.

## Step 4: Use the dev workspace

At this point, you have a fully built workspace, and you should begin working on
your React application.

### Set up your React app

We'll begin our sample project for this tutorial by
[bootstrapping the React app](https://github.com/facebook/create-react-app)
provided by the language's creators.

To do this, go to the **Workspaces** page of your Coder deployment and click
**Terminal**. Run the following to create the skeleton for your application:

```console
npx create-react-app coder-app
```

The command creates a new directory called **coder-app** that contains the
initial code and configuration settings for your app.

### Start the development server

Before you begin working on your application, we recommend starting up the
development server so that you can preview the changes you make to your project.

You can switch into your app's directory and start the React development server
(which listens on port 3000) using the Coder deployment's Terminal:

```console
cd coder-app
yarn start
```

### Preview your application

Once you've started your server, you can preview your application using the web
browser of your choice (you must have [dev URLs](../../admin/devurls.md) enabled
for this to work). To do so:

1. On the **Workspace Overview** of your Coder deployment, go to **Dev URLs**
   and click **Add URL**.
1. In **Port**, enter **3000**.
1. Click **Save**.
1. Use the generated URL in a web browser to see your application.

### Modifying your application code

At this point, you can open the IDE to start working on your project.

On the **Workspace Overview**, click Open Editor. Choose the editor you'd like
to work in (Coder will open this in a new tab). Once the editor window opens,
you can navigate to your **coder-app** directory and begin working.

You can see the changes you're making in the web browser whose URL points to
your application.
