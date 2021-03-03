---
title: Managing Git Configuration
description: Learn how to manage your Git configuration in Coder.
---

This guide will show you how to manage Git configuration through the system,
global, and repo levels.

## How to use the System and Global configurations

For customers seeking organizational (system-level) `.gitconfig` defaults, we recommend
adding a default configuration into the `/etc/gitconfig` file of each image associated
to the organization:

```bash
[url "git@github.com:"]
    insteadOf = https://github.com/
```

For users seeking to override the system `.gitconfig` with a global setting of their
own, we recommend including `.gitconfig` and other personal configuration files in
the `home/coder` directory. [Learn more about environment personalization.](https://coder.com/docs/environments/personalization#dotfiles-repo)

## A Coder-injected configuration

If there is no system-level `.gitconfig` in the image, or user-defined `.gitconfig`
in the environment, Coder will inject a `.gitconfig` file into the enviornment upon
creation, setting the `user.name` and `user.email` values to the Coder account values.
