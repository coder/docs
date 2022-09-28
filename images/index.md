---
title: "Images"
description: Learn about reproducibility in Coder.
---

Coder creates development environments called
[workspaces](../workspaces/index.md) using container images as the blueprints.

For organizations, container images (sometimes referred to as images) are the
foundation for achieving consistency and productivity across developers while
eliminating configuration drift, downstream bugs, and risks related to outdated
development environments.

Images contain the IDEs, CLIs, language versions, and dependencies users need to
work on software development projects. Users can create workspaces with the
image as the blueprint, then begin contributing immediately to the projects for
which the image was defined.

Coder integrates with many common container registries (including Artifactory,
Docker, AWS Elastic Container Registry, and Azure Container Registry). Container
registries store the images that you can then import into Coder. Images are
built using Dockerfiles.

You can nest images to reuse workspace configuration across development teams.

> [The Open Container Initiative (OCI) standard](https://opencontainers.org/)
> sets the standard for containers and images.

## In this section

<children></children>
