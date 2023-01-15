# SSH access

Before accessing your workspace via SSH:

- Your site manager must [enable access to workspaces using SSH]
- You must install the [Coder CLI] on your local machine

[enable access to workspaces using ssh]:
  ../admin/workspace-management/ssh-access.md
[coder cli]: ../cli/index.md

## Configuration

To access your servers via SSH, run the following using the Coder CLI:

```console
coder config-ssh
```

You should see the following returned:

```console
An auto-generated ssh config was written to "/Users/yourName/.ssh/config"
Your private ssh key was written to "/Users/yourName/.ssh/coder_enterprise"
You should now be able to ssh into your workspace
For example, try running
    $ ssh coder.backend
```

Your workspace is now accessible via `ssh coder.<workspace_name>` (e.g.,
`ssh coder.myEnv` if your workspace is named `myEnv`).

### SSH port forwarding

To start an SSH port forwarding session:

```console
ssh -L [localport]:localhost:[remoteport] coder.[workspace]
```

| Parameter    | Description                                                    |
| ------------ | -------------------------------------------------------------- |
| `localport`  | The port to use on your local machine (e.g., `localhost:3000`) |
| `remoteport` | The port of the server you want to access in the workspace     |

> You can use either HTTP or HTTPS, though the latter may result in
> certificate-related errors.

At this point, you can access the server in the browser using the `localport`
value.

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
rsync -e "coder ssh" -a --progress ~/project user@coder.<workspace-name>:~/project
```
