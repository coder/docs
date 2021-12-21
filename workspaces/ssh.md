---
title: "SSH access"
description: Learn how to configure SSH access to your workspaces.
---

Before accessing your workspace via SSH:

- Your site manager must [enable access to workspaces using SSH]
- You must install the [Coder CLI] on your local machine

[enable access to workspaces using ssh]:
  ../admin/workspace-management/ssh-access.md
[coder cli]: ../cli/index.md

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

To do so, use the flag `-e "coder ssh"` in your `rsync` transfer invocation. For
example, the following shows how you can transfer your home directory to your
workspace:

```console
rsync -e "coder ssh" -a --progress ~/. my-env:~
```

## Forwarding dev URLs

To access your server via SSH port forwarding:

1. [Create a dev URL](devurls.md)
1. Run `coder config-ssh` using the Coder CLI

Once done, you can configure the dev URL port using:

```console
ssh -L [localport]:localhost:[remoteport] coder.[workspace]
```

`localport` is the port you want to use on your local machine (e.g.,
`localhost:3000`), and `remoteport` matches the `port` of your dev URL.

After SSH port forwarding is configured, you can access the dev URL (e.g.,
`http://localhost:3000`) in a browser.
