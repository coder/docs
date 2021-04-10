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

Coder uses image tags to determine the image variant to pull to run an
environment.

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

### Rebuilds use the same tag, not the same image

The important thing to consider when modifying an existing image is whether a
change will break existing environments that others are using. Taking a semantic
versioning view of docker image tags may be overkill, but take care with changes
to prevent a rebuild from preventing a developer from working.

### Latest versus version numbered

Below are some examples of how a latest (or rolling) type of tag will behave and
how that differs from a specific version tag.

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

## Coder recommendation

Use image names and tags that follow a consistent format across the organization
so that users will be comfortable selecting either a versioned or rolling tag.

To avoid pulling images from dockerhub or another external source, always use
internal registry names and tags or namespaces that the organization controls.

`registry:port/company/department/software:majorversion`

- `registry:port` by using an internal image registry name, there is no risk of
  pulling an outside image with unapproved content.

- `company` if you're using an internal registry, company may be assumed.

- `department` can help setting a scope for who owns images and can patch or
  modify them. As more teams pick up development images, they may start using
  existing images and tags which can make it difficult to change them later.
- `software` being specific about which software systems are intended to be
  developed against using the image further reduces the coordination cost
  related to multiple teams sharing images.

- `majorversion` will likely correlated to an entire software stack which can be
  helpful in determining which version of various dependencies and build tools
  are present in the image. A developer is likely to span a couple of versions
  during a major version tick event and that's the perfect time to have mutliple
  environments running with separate dependencies.

This recommendation is based on assumptions that may or may not apply to any
given development organization today, and the applicability may change over
time. There is no `right way` as long as tags are meaningful to your teams and
don't create busywork or outages.
