# Image tag names

Coder uses image tags to determine the image variant to use when creating an
workspace.

Image tags are expressed using the following notation:

```text
<image>:<image-tag>
```

Examples include:

```text
ubuntu:rolling
ubuntu:latest
ubuntu:20.04
mycorp/myproject:v1
```

This article will walk you through how Coder handles image tags and what to
consider when working with image tags.

## Rebuilds use the same tag, not the same image

When modifying an existing image, be sure to consider whether the changes you're
making will break existing workspaces built using that image. You may want to
consider taking a semantic versioning view of your image tags for more critical
images.

## Tag behavior

The following examples show how different tagging schemes change how Coder uses
the image tag.

- If you build your workspace using a `ubuntu:rolling` or `ubuntu:latest` tag,
  Coder prompts you to rebuild for patches, security updates, and major version
  releases. If you're supporting a SaaS product or working on mobile apps, you
  can opt for this to ensure that your tools stay up-to-date.

- If you build your workspace using a specific version tag (e.g.,
  `ubuntu:20.04`), Coder will alert you regarding patches and security updates
  so that you rebuild your workspace (you won't get these fixes otherwise).
  Coder does not, however, alert you regarding minor releases (e.g., movement
  from `20.04` to `20.10`). This is a good option for those offering long-term
  support of software with lengthier version cycles or those supporting multiple
  versions where you expect to revert to a prior release to investigate and fix
  issues.

- If you build your workspace using `mycorp/myproject:v1`, the image is
  associated with a specific project's major version. You can apply the `:v1`
  tag to the most recent build for the image, while you can use `:v1.3` or
  `:v1.3.1` to pull a more specific tag version.

## Recommendations

- Use image names and tags that follow a consistent format across the
  organization so that users will be comfortable selecting either a _versioned_
  or a _rolling_ tag.

- To avoid pulling images from Docker Hub (or another external source), use
  internal registry names and tags or namespaces that are controlled by your
  organization.

## Sample tagging scheme

Let's say that you have the following tag:

```text
registry:port/company/department/software:majorversion
```

Here's the information that can be gleaned from the tag name:

- `registry:port`: By using an internal image registry name, there's no risk of
  pulling an outside image with unapproved content
- `company`: If you're using an internal registry, you can omit this parameter
- `department`: Helps set the scope for who owns the image and therefore can
  patch/modify the image
- `software`: Offers information about which software systems should be
  developed using the image
- `majorversion`: Can correlate to a software stock; helpful in determining
  which version of various dependencies and build tools are present in the image

The above recommendations are based on assumptions that may not apply to all
organizations, and their applicability may change over time. There's no "right
way" to tag your images, as long as your tags are meaningful to your teams and
don't cause issues with your developers' workflows.
