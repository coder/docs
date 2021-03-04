---
title: Managing Git Configuration
description: Learn how to configure Git in Coder.
---

This guide will show you how to manage your Git configuration in Coder.

## Personal git Configurations

By default, Coder injects a .gitconfig file into each environment if there isn't
a system-level or a user-defined .gitconfig file; the file sets the user name
and email address using the information associated with the user's Coder
account.

We recommend that each Coder user set and modify their personal .gitconfig file
using a [~/personalize script](../environments/personalization.md).

**Preferences defined using individual .gitconfig files take precedence over
system-level settings.**

## System and Global git Configurations

If you have a set of git configuration instructions that apply to your
organization as a whole, you can define and use a system-level git
configuration. We suggest adding the System-level `.gitconfig` directly to the
image's Dockerfile:

```Dockerfile
# Add system-level gitconfig
COPY ["gitconfig", "/etc/gitconfig"]
```

As you can see from the example, Coder stores system-level git configurations
under **/etc/gitconfig**. If present, Coder applies the settings to each git
repository present. However, any Coder user can override system-level settings
using global or worktree git configurations.
