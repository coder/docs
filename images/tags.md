---
title: "Tags"
description: Learn how to manage image versions inside Coder.
---

<a href="https://docs.docker.com/engine/reference/commandline/tag/"
target="_blank" rel="noreferrer noopener">Image tags</a> are variants of the
original (or base) image. Users can publish new image tags containing updated
dependencies and tooling useful for work on the project.

## Image tag lifecycle

Coder uses tags for images to determine which image a user intends create a
workspace from. Examples of tags: 

    ubuntu:rolling
    ubuntu:20.04
    codercom/enterprise-node:ubuntu
    mycorp/myproject:v1

For the first pair, they both refer to Ubuntu base images however the way each
tag is used is quite different. The `:20.04` tag stays with that release and is
updated with patches and fixes but not typically new functionality. For new
functionality, the `:rolling` tag will move up to `:20.10` and eventually `:21.04`
as the new versions are released. 

In Coder, if a workspace is created using a `:20.04` style tag and the supported
software moves on to require `:20.10`, the user will not be alerted. Coder will
inform the developer when patches and updates are available so they can rebuild
the workspace to get rid of the outdated versions. This is good for long-term
support of software that has lengthy version cycles or multiple supported
versions where jumping back to "last year's release" to investigate or hotfix
can be expected.

If the workspace is created from a `:rolling` or `:latest` sort of tag, the
workspace will prompt to be rebuilt for the same patching and security updates
but will also prompt for a rebuild when a major version increase happens. This
may be preferred for support SaaS or mobile apps that update frequently and need
to stay current for everyone. 

For the `codercom/enterprise-node:ubuntu` image, the name denotes the company
and software architecture ("node") while the tag specifies the base image.
Without a version, it can be assumed that it will operate like a rolling
tag. It also implies that other flavors such as `:centos` or `:arch` may be
available if users prefer those. 

Finally, the `mycorp/myproj:v1` image can help make it clear that the image is
tightly associated with a specific project's major version. The `:v1` tag can
be applied to the most recent build for that image while more specific `:v1.3`
or even `:v1.3.1` tags allow users to summon a very specific tag. 

#### Summary

*  `latest` will always prompt the user to rebuild whenever the tag is placed 
   on a new image
*  `v1` will prompt the user to rebuild whenever the tag is placed on a new 
   image but shouldn't move to `v2`
*  `ubuntu` or another sort of tag will behave as `latest` but implies the
   existence of alternatives
*  `v1.3.1` would typically not be added to Coder unless a user needs to go
   back to a very specific image from

## Add a tag

To add a tag to Coder:

1. Go to **Images** and find the original image.
1. Open the image, then click **Add Tag** in the top-right.
1. Provide the **tag name** when prompted.

When someone publishes a new version of a tag, Coder notifies users of that tag
with active environments.

## Default tag

Each image has a default tag. The default tag appears at the top of the list and
is indicated by an asterisk. Coder automatically selects the default tag when
you create an environment.

### Changing the default tag

> We encourage you to update an image's default tag whenever you publish new
> tags since Coder suggests the default tag whenever someone creates a new
> environment. This change does not affect existing environments.

When adding a tag, check **Set tag as default** to make it the default tag for
that image.

![Set Default Tag](../assets/default-tag.png)

To use an existing tag as the default tag, click the **vertical ellipses** for a
tag and select **Make default**.

![Set Existing Tag as Default](../assets/existing-tag-as-default.png)
