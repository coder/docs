---
title: "Lifecycle"
description: "Learn about the workspace lifecycle."
---

A Coder workspace is designed to shutdown (triggered by either scheduled
workspace inactivity or manually by users and administrators) and be rebuilt.

The persistent volume claim (or `/home/<username>`) mounted to the workspace
ensures that the workspaces retain cloned code repositories and other
personalization settings.

You can manage a Coder workspace's lifecycle at the organization-level to auto
shutdown after a defined period of inactivity or when administrators want to
force workspace rebuilds.

## Rebuilds

Rebuilding a [workspace](index.md) allows you to update to the latest image,
edit resource requests, or restart your workspace after a shutdown.

Only the `/home/<username>` directory persists between rebuilds. Rebuilds do not
affect configurations and source code within the `/home/<username>` subtree,
even if the underlying [image](../images/index.md) or its dependencies change.

**Note:** `username` is defined in the image. See
[Docker's image documentation](https://docs.docker.com/engine/reference/builder/#user)

## Auto-start

Users can configure a workspace
[auto-start](https://coder.com/docs/coder/latest/workspaces/autostart) time,
which sets the time when Coder will rebuild and start their workspaces. Users
typically set this time to coincide with the start of their working day.

## Auto-off

Organizations can set an
[auto-off inactivity threshold](../admin/workspace-management/shutdown.md).
After a workspace hasn't been accessed for the specified threshold, it is shut
down. A stopped workspace requires a [rebuild](#Rebuilds) before you can access
it again.

## Hooks

Coder exposes a few hooks during the build process. Once a workspace is
available and running on an underlying host, the following steps are taken:

1. **Injection of secrets into the workspace**: Coder injects authentication for
   the [Coder CLI](https://github.com/coder/coder-cli), allowing the CLI to
   perform authenticated CLI commands. If your Coder instance is configured with
   a Git provider, your SSH key pair is injected during this step as well,
   allowing it to perform authenticated `git` operations.

1. **Execution of `/coder/configure`**: Execution of this script, which is
   included in the workspace image, allows [images](../images/index.md) to
   perform startup operations that are consistent across all of the workspaces
   that use the image. If you need your image to include modifications to
   `/home/<user>`, include the instructions in this script.

   In other words, the configure script is _not_ run as the root user but as the
   `/home/<user>`, so configurations are stored in `/home/<user>`. You may also
   run commands with `sudo`, but these changes will not persist in
   `/home/<user>`.

1. **Execution of `~/personalize`**: Execution of this script allows you to
   customize your personal development workspace on each rebuild. Coder injects
   the personalize script into the workspace and includes cloning logic if a
   user has specified a dotfiles repo. Read more on personalization
   [here](./personalization.md).
