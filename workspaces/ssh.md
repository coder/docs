---
title: "SSH access"
description: Learn how to configure SSH access to your workspaces.
---

Before using, configuring, and accessing your workspace via SSH:

- Your site manager must _not_ have
  [disabled access](../admin/workspace-management/ssh-access.md) via SSH
- You must have the [Coder CLI](../cli/index.md) installed on your local machine
  before proceeding.

## Configuration

You can access your workspaces via SSH by configuring your local machine as
follows:

```console
$ coder config-ssh

An auto-generated ssh config was written to "/Users/yourName/.ssh/config"
Your private ssh key was written to "/Users/yourName/.ssh/coder_enterprise"
You should now be able to ssh into your workspace
For example, try running
    $ ssh coder.backend
```

Your workspace is now accessible via `ssh coder.<workspace_name>` (e.g.,
`ssh coder.myEnv` if your workspace is named `myEnv`).

## Reconfiguration

You will need to rerun the `coder config-ssh` command if:

- You reconfigure or modify your keypair using the Coder dashboard
- You add additional workspaces (running this command will ensure that your
  **~/.ssh/config** file populates correctly with alias targets)

## Using SFTP

Coder supports the use of the SFTP protocol. To connect to a workspace using
SFTP, run `sftp coder.<workspace_name>`.

## Using rsync

You can use `rsync` to transfer files to and from Coder.

To do so, use the flag `-e "coder sh"` in your `rsync` transfer invokation. For
example, the following shows how you can transfer your home directory to your
workspace:

```console
rsync -e "coder sh" -a --progress ~/. my-env:~
```
