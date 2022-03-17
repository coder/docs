---
title: Custom image creation
description: Learn how to write custom images for use with Coder.
---

Custom images allow you to define workspaces that include the dependencies,
scripts, and user preferences helpful for your project.

This guide assumes that you're familiar with:

- [Dockerfiles](https://docs.docker.com/engine/reference/builder/)
- [docker login](https://docs.docker.com/engine/reference/commandline/login/)
- [docker build](https://docs.docker.com/engine/reference/commandline/build/)
- [docker push](https://docs.docker.com/engine/reference/commandline/push/)

## Resources

For ideas on what you can include in your images, see:

- [Sample Coder images](https://github.com/coder/enterprise-images)
- [Guide: Node.js image for Coder](../guides/customization/node)

## Creating a custom image

Instead of starting from scratch, we recommend extending one of our
[sample images](https://github.com/coder/enterprise-images):

```Dockerfile
# Dockerfile
FROM codercom/enterprise-base:ubuntu

USER root

# Add software, files, dev tools, and dependencies here
RUN apt-get install -y ...
COPY file ./

USER coder

...
```

Please note:

- Coder workspaces mount a
  [home volume](../workspaces/personalization#persistent-home). Any files in the
  image's home directory will be replaced by this persistent volume. If you have
  install scripts (e.g., those for Rust), you must configure them to install
  software in another directory.

- If you're using a different base image, see our
  [image minimum requirements](https://github.com/coder/enterprise-images/#image-minimums)
  to make sure that your image will work with all of Coder's features.

- You can leverage your Coder deployment and its compute resources to build images inside a
  [CVM](../admin/workspace-management/cvms.md)-enabled Coder workspace with
  Docker installed (see our
  [base image](https://github.com/coder/enterprise-images/tree/main/images/base)
  for an example of how you can do this). This is a great way to free up your local machine from the compute-heavy image building process.

- If you're using CVM-only features during an image's build time (e.g., you're
  [pre-loading images](https://github.com/nestybox/sysbox/blob/master/docs/quickstart/images.md#building-a-system-container-that-includes-inner-container-images--v012-)
  in workspaces), you may need to install the
  [sysbox runtime](https://github.com/nestybox/sysbox) onto your local machine
  and build your images locally. Note that this isn't usually necessary, even if
  your image installs and enables Docker.

- If you're installing additional IDEs like JetBrains, you may need to also install the language interpreter, development kit, build tool, or compiler as part of the image. Check with your IDE for what components they install.

## Example: Installing a JetBrains IDE

This snippet shows you how to install a JetBrains IDE onto your image so that
you can use it in your Coder workspace:

```Dockerfile
# Dockerfile
FROM ...

# Install IDEs as root
USER root

RUN mkdir -p /opt/[IDE]
RUN curl -L \
"https://download.jetbrains.com/product?code=[CODE]&latest&distribution=linux" \
| tar -C /opt/[IDE] --strip-components 1 -xzvf -

# Add a binary to the PATH that points to the IDE startup script.
RUN ln -s /opt/[IDE]/bin/idea.sh /usr/bin/[IDE]

# Set back to coder user
USER coder
```

Make sure that you replace `[IDE]` with the name of the IDE in lowercase and
provide its
[corresponding `[CODE]`](https://plugins.jetbrains.com/docs/marketplace/product-codes.html).

Here's how to install the IntelliJ IDEA Ultimate IDE onto your image:

```Dockerfile
# Dockerfile
FROM ...

USER root

# Install intellij idea ultimate
RUN mkdir -p /opt/idea
RUN curl -L "https://download.jetbrains.com/product?code=IU&latest&distribution=linux" \
| tar -C /opt/idea --strip-components 1 -xzvf -

# Create a symbolic link in PATH that points to the Intellij startup script.
RUN ln -s /opt/idea/bin/idea.sh /usr/bin/intellij-idea-ultimate

# Set back to coder user
USER coder
```

Here's how to install the IntelliJ PyCharm Professional IDE onto your image:

```Dockerfile
# Dockerfile
FROM ...

USER root

# Install pycharm professional 
RUN mkdir -p /opt/pycharm
RUN curl -L "https://download.jetbrains.com/product?code=PCP&latest&distribution=linux" | tar -C /opt/pycharm --strip-components 1 -xzvf -

# Add a binary to the PATH that points to the pycharm startup script.
RUN ln -s /opt/pycharm/bin/pycharm.sh /usr/bin/pycharm

# Set back to coder user
USER coder
```