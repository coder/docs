---
title: "Self-contained workspace builds"
description: Learn how to toggle self-contained workspace builds.
---

Currently, there are two ways in which the workspace boot sequence can occur:

1. Remotely: Coder uploads assets (including the Coder agent, code-server, and
   JetBrains Projector) from `coderd` to a workspace.
1. Self-contained: workspaces control the boot sequence internally; the
   workspace downloads assets from `coderd`. This requires `curl` to be 
   available in the image.

Beginning with v1.30.0, the default is **self-contained workspace builds**,
though site managers can toggle this feature off and opt for remote builds
instead.

> Coder plans to deprecate remote workspace builds in the future.

To toggle self-contained workspace builds:

1. Log into Coder.
1. Go to Manage > Admin.
1. On the Infrastructure page, scroll down to **Workspace container runtime**.
1. Under **Enable self-contained workspace builds**, flip the toggle to **On**
   or **Off** as required.
1. Click **Save workspaces**.

> Build errors are typically more verbose for remote builds than with
> self-contained builds.

## Known issues

At this time, Coder does not support certificate injection with self-contained
workspace builds.
