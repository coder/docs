---
title: Managing Git Configuration
description: Learn how to configure Git with Coder.
---

This guide will show you how to manage Git configuration through the system,
global, and repo levels.

## How to use the System and Global configurations

For scenarios whereby a set of git configurations should apply across an organization,
we recommend using a System-level git configuration. System-level git configurations
are located at `/etc/gitconfig`. These settings are applied to each git repository,
but may be overriden using global or worktree git configurations.

We suggest adding the System-level `.gitconfig` directly in the image Dockerfile.
Below is an example of such:

```Dockerfile
# Add system level gitconfig
COPY ["gitconfig", "/etc/gitconfig"]
```

We recommend having users set a personal `.gitconfig` file via the `~/personalize`
script, though it will override the System-level `etc/gitconfig` default set in
the image.

## A Coder-injected configuration

By default, Coder will inject a `.gitconfig` into the environment using the name
and email associated with your Coder login, given there is no System-level or user-defined
`.gitconfig`.
