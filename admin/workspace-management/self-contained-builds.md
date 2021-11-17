---
title: "Self-contained workspace builds"
description: Learn how to enable self-contained workspace builds.
state: alpha
---

By default the Coder workspace boot sequence occurs remotely -- Coder uploads
assets (including the Coder agent, code-server, and JetBrains Projector) from
`coderd` to a workspace.

However, Coder offers the option of using **self-contained workspace builds**.
Enabling this option changes the Coder deployment so that workspaces control the
boot sequence internally, with the workspace downloading assets from `coderd`.

> At this time, Coder does not support certificate injectioin with
> self-contained workspace builds.

To enable self-contained workspace builds:

1. Log into Coder.
1. Go to Manage > Admin.
1. On the Infrastructure page, scroll down to **Workspace container runtime**.
1. Under **Enable self-contained workspace builds**, flip the toggle to **On**.
1. Click **Save workspaces**.

> Build errors are typically more verbose for remote builds than with
> self-contained builds.
