---
title: "Tags"
description: Learn how to manage image versions inside Coder.
---

<a href="https://docs.docker.com/engine/reference/commandline/tag/"
target="_blank" rel="noreferrer noopener">Image tags</a> are variants of the
original (or base) image. Users can publish new image tags containing updated
dependencies and tooling useful for work on the project.

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

To use an existing tag as the default tag, click the **vertical ellipsis** for a
tag and select **Make default**.

![Set Existing Tag as Default](../assets/existing-tag-as-default.png)

## Image tag lifecycle

Coder uses image tags to determine which image variant on which the user wants
to base their environment.

Image tags are expressed using the following notation:

```text
<image>:<image-tag>
```

Examples include:

```text
ubuntu:20.04
ubuntu:rolling
codercom/enterprise-node:ubuntu
mycorp/myproject:v1
```

The name formatting of the tag will change the way Coder behaves regarding image
updates:

- If you build your environment using a `ubuntu:rolling` or `ubuntu:latest` tag,
  Coder prompts you to rebuild for patches, security updates, and major version
  releases. If you're supporting a SaaS product or working on mobile apps, you
  may opt for this to ensure that your tools stay up-to-date.

- If you build your environment using a specific version tag (e.g.,
  `ubuntu:20.04`), Coder will alert you regarding patches and security updates
  so that you rebuild your environment (you won't get these fixes otherwise).
  Coder does not, however, alert you regarding minor releases (e.g., movement
  from `20.04` to `20.10`). This is a good option for those offering long-term
  support of software with lengthier version cycles or those supporting multiple
  versions where you expect to revert back to a prior release to investigate and
  fix issues.

- If you build your environment using a tag like
  `codercom/enterprise-node:ubuntu`, the image name indicates the company and
  software architecture (also known as the node), while the tag specifies the
  base image. Without any additional information, such as a version number, you
  can expect this to operate like a `rolling` or `latest` tag. You can also
  assume there are other variants, such as `codercom/enterprise-node:centos` or
  `codercom/enterprise-node:arch`.

- If you build your environment using `mycorp/myproject:v1`, the image is
  associated with a specific project's major version. You can apply the `:v1`
  tag to the most recent build for the image, while you can use `:v1.3` or
  `:v1.3.1` to pull a more specific tag version.
