# Git configuration

This guide will show you how to manage your Git configuration in Coder.

## Personal git configurations

Coder will create a global Git configuration file located at `~/.gitconfig` in
all newly created workspaces. Coder will also set the user name and email
address based on the user's Coder account information.

This step occurs before [coder/configure](images/../../../images/configure.md)
and [personalization](../../workspaces/personalization.md). This means that you
can use both files to override the default `.gitconfig` created by Coder.

> If there's already a `.gitconfig` file, Coder will not recreate a default
> version when you rebuild a workspace.

We recommend that each Coder user set and modify their personal `.gitconfig`
file using the [~/personalize script](../../workspaces/personalization.md).
**Preferences defined using individual `.gitconfig` files take precedence over
system-level settings.**

## System and global Git configurations

If you have a set of instructions that apply to your organization as a whole,
you can define and use a system-level Git configuration file. We suggest adding
the system-level `.gitconfig` directly to the image's Dockerfile:

```Dockerfile
# Add system-level gitconfig
COPY ["gitconfig", "/etc/gitconfig"]
```

System-level git configurations live under `/etc/gitconfig`. If this file is
present, `git` applies the settings defined to each repository. However, any
Coder user can override system-level settings using global or worktree git
configurations.

For more information on Git configuration, refer to the
[official documentation](https://git-scm.com/docs/git-config).
