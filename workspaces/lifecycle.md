---
title: "Lifecycle"
description: "Learn about the workspace lifecycle."
---

Workspaces are designed to sustain scheduled shutdowns and rebuilds. An
workspace lifecycle resilient to stops and starts means you can save dollars on
cloud compute and justify more powerful dev machines :).

## Rebuilds

Rebuilding an [workspace](index.md) allows you to update to the latest image,
edit resource requests, or restart your workspace after a shutdown.

Only the `/home/<username>` directory persists between rebuilds. Rebuilds do not
affect configurations and source code within the `/home/<username>` subtree,
even if the underlying [image](../images/index.md) or its dependencies change.

**Note:** `username` is defined in the image. See
[Docker's image documentation](https://docs.docker.com/engine/reference/builder/#user)

## Auto-off

Organizations can set an
[auto-off inactivity threshold](../admin/workspace-management/shutdown.md).
After a workspace hasn't been access for the specified threshold, it is
shutdown. A stopped workspace requires a [rebuild](#Rebuilds) before you can
access it again.

## Hooks

Coder exposes a few hooks during the build process. Once a workspace is
available and running on an underlying host, the following steps are taken:

1. **Injection of secrets into the workspace**: Coder injects authentication for
   the [Coder CLI](https://github.com/cdr/coder-cli), allowing the CLI to
   perform authenticated CLI commands. If your Coder instance is configured with
   a Git provider, your SSH key pair is injected during this step as well,
   allowing it to perform authenticated `git` operations.

1. **Execution of `/coder/configure`**: Execution of this script allows
   [images](../images/index.md) to perform startup operations consistent across
   all of the workspaces that use the image. If you need your image to include
   modifications to `/home`, include the instructions in this script.

1. **Execution of ~/personalize`**: Execution of this script allows you to
   customize your personal development workspace on each rebuild. Read more on
   personalization [here](./personalization.md).
