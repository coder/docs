---
title: Command execution recording
description: Learn how enable command execution recording in workspaces.
state: alpha
---

The command execution recording feature allows you to record all commands run by
users in a workspace. More specifically, enabling this feature adds a privileged
sidecar to your workspaces that logs all `exec` system calls. This is helpful
for increasing security, such as when using Docker in CVMs, as well as aiding
troubleshooting (i.e., troubleshooting cloud-related issues by reviewing actions
taken by the user).

## Requirements

Use of the command execution recording functionality requires a host Linux
kernel >= 5.8.

## Enable command execution recording

To enable command execution recording:

1. Log into Coder as a site manager.
1. Go to **Manage** > **Admin**.
1. On the **Infrastructure** page, scroll down to the **Workspace container
   runtime** section.
1. Toggle on **Enable workspace command execution recording**.
1. Click **Save workspaces**.

![Command recording toggle](../../assets/admin/command-recording.png)
