---
title: Docker
description: Learn how to deploy a workspace provider to a Docker instance.
state: alpha
---

This article walks you through the process of deploying a workspace provider to a remote VM instance using docker.

## Prerequisites

You must have a provisioned VM with the docker engine installed and running. The docker engine must be at least version [20.10][docker-engine-version]. 

The VM must be accessible over `ssh`.

The coder deployment must be accessible from containers deployed inside the VM.

## 1. Create a new ssh key

Coder will use ssh to connect to the remote VM and communicate with the docker engine. It is advised to create a new ssh key for this purpose, and do not reuse this key. Save this key somewhere secure, as it will be needed if you need to edit the workspace provider in the future.

> &#10071; Password protected ssh keys are not currently supported. The ssh key must be unencrypted.

```bash
ssh-keygen -t ed25519 -C remote-c4d -f $HOME/.ssh/remote_c4d -N ""
```

## 2. Add ssh key to remote VM

Add the ssh key to the remote VM's `authorized_keys` file. This will allow us to ssh using the new `remote_c4d` key.

```bash
# Replace 'remote-user@192.0.2.10' with your VM's user and host/ip.
ssh-copy-id -f -i $HOME/.ssh/remote_c4d.pub remote-user@192.0.2.10
```

## 3. Verify the key

Verify the key can ssh into your remote VM.

```bash
# Replace 'remote-user@192.0.2.10' with your VM's user and host/ip.
ssh remote-user@192.0.2.10 -o IdentitiesOnly=yes -i $HOME/.ssh/remote_c4d 'echo All good!'
```

## 4. Create the provider

On your docker deployment, make sure to enable the Remote Docker Providers feature flag in your user settings.

1. Log in to Coder, and go to **Account** > **Feature Preview**

![See feature flags](../../../assets/deployment/docker/feature-flag-setting.png)

2. Enable **Remote Docker Providers**

![Enable feature flag](../../../assets/deployment/docker/docker-feature.png)

3. Go to **Manage** > **Workspace providers**
4. Click the dropdown in the top right corner to launch **Create Docker Provider**

![Create docker provider](../../../assets/deployment/docker/create-docker-provider.png)

5. Fill out the provider form
   1. Name the docker provider
   2. For the **Docker Daemon URL**, use `unix:///var/run./docker.sock`
   3. SSH configuration section
      1. Use the ssh url for the remote vm, and **include the port**. Eg: `remote-user@192.0.2.10:22`
      2. Copy the private key that we created earlier, `cat $HOME/.ssh/remote_c4d`
      3. Run the keyscan in the form to copy over the known host verification. Copy the output. Eg: `ssh-keyscan -p 22 -H 192.0.2.10`
      4. Optionally set the access url to an ip or url that workspaces can use to access coderd.

![Docker ssh config](../../../assets/deployment/docker/docker-ssh-config.png)






[docker-engine-version]: https://docs.docker.com/engine/release-notes/#20100
