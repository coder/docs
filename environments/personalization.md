---
title: "Personalization"
description: Learn how to personalize your Environment to augment its base Image.
---
Your Coder development Environment strikes a balance between consistent team configuration and personal customization.
While the Environment [Image](../images/index.md) standardizes system dependencies for development, Coder offers a few different mechanisms
for customizing the Environment to best fit your needs.

## Persistent Home

The `/home` volume is bound to your Environment. Its contents are persisted between shutdowns and  rebuilds.
This ensures that personal configuration files like `~/.gitconfig` and `~/.zshrc`, as well as source code and project files, are not disrupted.

Data outside `/home` is provided by the Environment [Image](../images/index.md) and is reset between by Environment [rebuilds](./lifecycle.md). 

## ~/personalize

For cases where personal configuration of system files is needed, Environments expose the [~/personalize rebuild hook](./lifecycle.md#hooks).
Consider the case where you want to use the `fish` shell as your default shell, but the Environment image doesn't include the package.
The following `~/personalize` scripts would install `fish` and change the default shell *each time the environment is rebuilt*.

```bash
#!/bin/bash

echo "--Starting personalize"

sudo apt-get update
sudo apt-get install -y fish
sudo chsh -s /usr/bin/fish $USER
```

The Environments page shows the log output of the `~/personalize` script in the build log.

![Enable privileged environment](../assets/personalize-log.png)
