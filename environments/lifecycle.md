---
title: "Lifecycle"
description: "Learn about the environments lifecycle."
---

Environments are designed to sustain scheduled shutdowns and rebuilds. An
environment lifecycle resilient to stops and starts means you can save dollars
on cloud compute and justify more powerful dev machines :).

## Rebuilds

Rebuilding an [environment](index.md) allows you to update to the latest image,
edit resource requests, or restart your environment after a shutdown.

Only the `/home/<username>` directory persists between rebuilds. Rebuilds do not
affect configurations and source code within the `/home/<username>` subtree,
even if the underlying [image](../images/index.md) or its dependencies change.

**Note:** `username` is defined in the image. See
[Docker's image documentation](https://docs.docker.com/engine/reference/builder/#user)

## Auto-off

Organizations can set an
[auto-off inactivity threshold](../admin/environment-management/shutdown.md).
After an environment hasn't been access for the specified threshold, it is
shutdown. A stopped environment requires a [rebuild](#Rebuilds) before you can
access it again.

## Hooks

Coder exposes a few hooks during the build process. Once an environment is
available and running on an underlying host, the following steps are taken:

1. **Injection of secrets into the environment**: Coder injects authentication
   for the [Coder CLI](https://github.com/cdr/coder-cli), allowing the CLI to
   perform authenticated CLI commands. If your Coder instance is configured with
   a Git provider, your SSH key pair is injected during this step as well,
   allowing it to perform authenticated `git` operations.

1. **Execution of `/coder/configure`**: Execution of this script allows
   [images](../images/index.md) to perform startup operations consistent across
   all of the environments that use the image. If you need your image to include
   modifications to `/home`, include the instructions in this script.

1. **Execution of ~/personalize`**: Execution of this script allows you to
   customize your personal development environment on each rebuild. Read more on
   personalization [here](./personalization.md).
