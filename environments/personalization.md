---
title: "Personalization"
description: Learn how to personalize your Environment to augment its base Image.
---

Your Coder development Environment strikes a balance between consistent team
configuration and personal customization.
While the Environment [Image](../images/index.md) standardizes system
dependencies for development, Coder offers a few different mechanisms
for customizing the Environment to best fit your needs.

## Persistent Home

The `/home/<username>` volume is bound to your Environment. Its contents are persisted
between shutdowns and rebuilds. This ensures that personal configuration files
like `~/.gitconfig` and `~/.zshrc`, as well as source code and project files,
are not disrupted.

Data outside `/home/<username>` is provided by the Environment [Image](../images/index.md)
and is reset between by Environment [rebuilds](./lifecycle.md).

## ~/personalize

For cases where personal configuration of system files is needed, Environments
expose the [~/personalize rebuild hook](./lifecycle.md#hooks). Coder executes
this script every time the Environment is rebuilt.

Consider the case where you want to use the `fish` shell as your default shell,
but the Environment image doesn't include the package. The following
`~/personalize` scripts would install `fish` and change the default shell
_each time the environment is rebuilt_.

```bash
#!/bin/bash

echo "--Starting personalize"

sudo apt-get update
sudo apt-get install -y fish
sudo chsh -s /usr/bin/fish $USER
```

**Note:** The `-y` flag is required to continue through any prompts.
Otherwise, the `~/personalize` script will abort.

The Environments page shows the log output of the `~/personalize` script in
the build log.

![Enable privileged environment](../assets/personalize-log.png)

## Git Integration

Once your site manager has [set up a Git service](../admin/git.md), you can link
your Coder account. This will authenticate all
`git` operations performed in your Environment. See how to [link your account](https://help.coder.com/hc/en-us/articles/360057612153-Linking-Git-Accounts).

## Dotfiles Repo

A **dotfiles repository** is a Git repository that contains your personal
Environment preferences in the form of static files and setup scripts.

We recommend configuring a dotfiles repo (which Coder then clones to your home
directory) to ensure that your preferences are applied whenever your
Environment turns on or you create a new Environment.

At startup, Coder clones this repository into `~/dotfiles`. If an executable
`~/dotfiles/install.sh` is present, it is executed. If not, all dot-prefixed files
are symlinked into your home directory.

Read more about dotfiles repos [here](http://dotfiles.github.io/).

### Adding Your Dotfiles Repo to Coder

You can provide a link to your dotfiles repo that's hosted with the Git provider
of your choice under User Preferences:

![Dotfiles Preferences](../assets/dotfiles-preferences.png)
