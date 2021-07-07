---
title: "Openshift Image"
description: Learn how to make your Coder images compatible with Openshift.
---

> This is required if running with 'restricted' pods. Giving the `builder` service account in your project [anyuid](https://www.openshift.com/blog/managing-sccs-in-openshift) permissions makes these steps unnecessary.

First, you should be familiar with [creating an image for your coder workspace](../../../images/writing.md). Openshift by default will not allow the default `coder` user in the base image. To create a good experience in Coder, we recommend creating a new image specific for your Openshift namespace.

## Openshift Dockerfile

This dockerfile should extend your Coder image for a specific project. This allows the `coder` user to be used in the image within the project.

First we need to get the allowed uid range for the project. Select the project in which Coder was installed.

```bash
$ oc describe project coder | grep uid-range
openshift.io/sa.scc.uid-range=1000670000/10000
```

Knowing the allowed uid range, we can change the uid of the `coder` user in our image.

```dockerfile
# Change this to your docker image. 
FROM docker.io/codercom/enterprise-base:ubuntu

# Switch to root
USER root 
# As root, change the coder user id
RUN usermod -u 1000670000 coder

# Go back to the user 'coder'
USER coder
```

## Builtin Registry

This Dockerfile can be placed in the `openshift-image-registry` project's [build configs](https://docs.openshift.com/container-platform/4.7/cicd/builds/understanding-buildconfigs.html) to automatically build this project specific dockerfile each time the underlying image is updated.