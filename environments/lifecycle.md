---
title: "Lifecycle"
description: "Learn about the lifecycle of Environments."
---

Environments are designed to sustain scheduled shutdowns and rebuilds. An
environment lifecycle resilient to stops and starts means you can save dollars
on cloud compute and justify more powerful dev machines :).

## Rebuilds

Rebuilding an [Environment](index.md) allows you to update to the latest image,
edit resource requests, or restart your environment after a shutdown.

Only the `/home` directory is persisted between rebuilds. This allows the
Image to populated system development dependencies without interfering with any
source code or miscellaneous configuration unique to your individual development
environment.

## Auto-Off

Organizations can set an auto-off inactivity threshold. After an Environment
hasn't been access for the specified threshold, it is shutdown. A stopped
environment requires a [rebuild](#Rebuilds) before you can accessed it again.

## Hooks

Coder exposes a few hooks during the build process. Once an Environment
is available and running on and underlying host, the following steps are taken

1. `Injecting secrets into environment`  
Coder injects authentication for the
[Coder CLI](https://github.com/cdr/coder-cli), allowing
the latter scripts to perform authenticated CLI commands.
If your Coder instance is configured with a Git provider, your SSH key pair is
injected during this step as well, allowing the latter scripts to perform
authenticated `git` operations.

2. `Execution of /coder/configure`  
Execution of this script allows [Images](../images/index.md) to perform startup
operations consistent across all of its Environments. If an image needs to
perform modifications to the `/home`, it should do so in this script.

3. `Execution of ~/personalize`
Execution of this script allows you to customize your personal development Environment
on each rebuild. Read more [here](./personalization.md) on personalization.
