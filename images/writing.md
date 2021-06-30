---
title: Custom image creation
description: Learn how to write custom images for use with Coder.
---

Custom images allow you to define workspaces that include the dependencies,
scripts, and user preferences helpful for your project.

> If you're unfamiliar with how to create, build, and push Docker Images, please
> review [this tutorial by
> Docker](http://blog.shippable.com/build-a-docker-image-and-push-it-to-docker-hub)
> before proceeding.

## Creating a custom image

Instead of starting from scratch, we recommend extending one of our
[sample images](https://github.com/cdr/enterprise-images):

```Dockerfile
# Dockerfile
FROM codercom/enterprise-base:ubuntu

RUN apt-get install -y ...
COPY file ./

...
```

Please note:

- If you're using a different base image, see our
  [image minimum requirements](https://github.com/cdr/enterprise-images/#image-minimums)
  to make sure that your image will work with all of Coder's features.

- You can build images inside a
  [CVM](../admin/workspace-management/cvms.md)-enabled Coder workspace with
  Docker installed (see our [base
  image](https://github.com/cdr/enterprise-images/tree/main/images/base) for an
  example of how you can do this).

- If you're using CVM-only features during an image's build time (e.g., you're
  [pre-loading
  images](https://github.com/nestybox/sysbox/blob/master/docs/quickstart/images.md#building-a-system-container-that-includes-inner-container-images--v012-)
  in workspaces), you will need to install the [sysbox
  runtime](https://github.com/nestybox/sysbox) onto your local machine and build
  images locally. Note that this isn't usually necessary, even if your image
  installs and enables Docker.

## Example: Installing an IntelliJ IDE

This snippet shows you how to install an IntelliJ IDE onto your image so that
you can use it in your Coder workspace:

```Dockerfile
# Dockerfile
FROM ...

# Install IDEs as root
USER root

RUN mkdir -p /opt/[IDE]
RUN curl -L \
"https://download.jetbrains.com/product?code=[CODE]&latest&distribution=linux" \
| tar -C /opt/[IDE] --strip-components 1 -xzvf
RUN ln -s /opt/[IDE]/bin/clion.sh /usr/bin/[IDE]
```

Make sure that you replace `[IDE]` with the name of the IDE in lowercase and
provide its
[corresponding `[CODE]`](https://plugins.jetbrains.com/docs/marketplace/product-codes.html).

More specifically, here's how to install the CLion IDE onto your image:

```Dockerfile
# Dockerfile
FROM ...

USER root

# Install CLion
RUN mkdir -p /opt/clion
RUN curl -L \
"https://download.jetbrains.com/product?code=CL&latest&distribution=linux" \
| tar -C /opt/clion --strip-components 1 -xzvf
RUN ln -s /opt/clion/bin/clion.sh /usr/bin/clion
```

## Sample images

To get an idea of what you can include in your images, see:

- [Ben's Coder images](https://github.com/bpmct/cdr-images) (frequently referred
  to in [Coffee and Coder](https://community.coder.com/coffee-and-coder) and the
  [Coder blog](https://coder.com/blog))
- [Sample Coder images](https://github.com/cdr/enterprise-images)
