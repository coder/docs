---
title: "Lifecycle"
description: "Learn about the workspace lifecycle."
---

A Coder workspace is designed to shutdown and re-built, either by scheduled workspace inactivity or manually by users and administrators. The persistent volume claim or `/home/<username>` mounted to the workspace ensures checked out code repository and other personalization settings are retained. A Coder workspace's lifecycle can be administered at the organization-level to auto shut-down after a defined period of inactivity or when administrators want to force workspace re-builds. 

## Rebuilds

Rebuilding a [workspace](index.md) allows you to update to the latest image,
edit resource requests, or restart your workspace after a shutdown.

Only the `/home/<username>` directory persists between rebuilds. Rebuilds do not
affect configurations and source code within the `/home/<username>` subtree,
even if the underlying [image](../images/index.md) or its dependencies change.

**Note:** `username` is defined in the image. See
[Docker's image documentation](https://docs.docker.com/engine/reference/builder/#user)

## Auto-off

Organizations can set an
[auto-off inactivity threshold](../admin/workspace-management/shutdown.md).
After a workspace hasn't been accessed for the specified threshold, it is shut
down. A stopped workspace requires a [rebuild](#Rebuilds) before you can access
it again.

## Auto-start

Users can configure workspace [auto-start](https://coder.com/docs/coder/latest/workspaces/autostart) which rebuilds their workspaces at the start of their working day.

## Hooks

Coder exposes a few hooks during the build process. Once a workspace is
available and running on an underlying host, the following steps are taken:

1. **Injection of secrets into the workspace**: Coder injects authentication for
   the [Coder CLI](https://github.com/coder/coder-cli), allowing the CLI to
   perform authenticated CLI commands. If your Coder instance is configured with
   a Git provider, your SSH key pair is injected during this step as well,
   allowing it to perform authenticated `git` operations.

1. **Execution of `/coder/configure`**: Execution of this script, that is included in the workspace image, allows
   [images](../images/index.md) to perform startup operations consistent across
   all of the workspaces that use the image. If you need your image to include
   modifications to `/home/<user>`, include the instructions in this script. In other words, the configure script is not run as root but as the `/home/<user>` so configurations are stored in `/home/<user>`. You may also run commands as `sudo` which will not persist in `/home/<user>`.

1. **Execution of `~/personalize`**: Execution of this script allows you to
   customize your personal development workspace on each rebuild. Coder injects the personalize script into the workspace and it includes cloning logic if a user has specified a dotfiles repo. Read more on
   personalization [here](./personalization.md).
