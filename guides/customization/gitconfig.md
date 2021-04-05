---
title: Managing Git configuration
description: Learn how to configure Git in Coder.
---

This guide will show you how to manage your Git configuration in Coder.

## Personal git configurations

Coder will create a global git configuration file located at `~/.gitconfig` in
all newly created environments and set the user name and email address using the
information associated with the user's Coder account.

This step occurs before [coder/configure](images/../../../images/configure.md)
and [personalization](../../environments/personalization.md), which can be used
to override the default `.gitconfig` created by Coder. If there's already a
`.gitconfig` file, Coder will not recreate a default version when you rebuild an
environment.

We recommend that each Coder user set and modify their personal .gitconfig file
using the [~/personalize script](../../environments/personalization.md).

**Preferences defined using individual `.gitconfig` files take precedence over
system-level settings.**

## System and global git configurations

If you have a set of git configuration instructions that apply to your
organization as a whole, you can define and use a system-level git
configuration. We suggest adding the system-level `.gitconfig` directly to the
image's Dockerfile:

```Dockerfile
# Add system-level gitconfig
COPY ["gitconfig", "/etc/gitconfig"]
```

As you can see from the example, system-level git configurations live under
`/etc/gitconfig`. If present, `git` applies the settings to each repository.
However, any Coder user can override system-level settings using global or
worktree git configurations.

For more information on git configuration, refer to the
[official documentation](https://git-scm.com/docs/git-config)
