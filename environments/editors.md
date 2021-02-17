---
title: "Editors and IDEs"
description: Learn how to connect your favorite Editors and IDEs to your remote environment.
---

There are four primary ways you can connect an IDE to your Coder environment:

1. [VS Code Remote SSH](#vs-code-remote-ssh) with local VS Code
1. [VS Code in the browser](#vs-code-in-the-browser) with code-server
1. [JetBrains in the browser](##jetbrains-ides-in-the-browser) with JetBrains
   Projector
1. _Any_ local editor with [2-way file synchronization over
   SSH](https://help.coder.com/hc/en-us/articles/360058001313?__hstc=103542367.6151dcd6d50b6cb62a878734c4aad255.1608274456028.1608306470901.1608410536657.3&__hssc=103542367.75.1608410536657&__hsfp=974138608)
   and [1-way file
   synchronization](https://help.coder.com/hc/en-us/articles/360055767234-Setting-Up-a-One-Way-File-Sync).

## VS Code Remote SSH

Once you've [set up SSH access to Coder](./ssh.md), you can work on projects
from your local VS Code, connected to your Coder environment for compute, etc.

1. Open VS Code locally.
2. Make sure that you've installed [Remote -
   SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)
   extension
3. In VS Code's left-hand nav bar, click **Remote Explorer** and right-click on
   an environment to connect

![VS Code Remote Explorer](../assets/vscode-remote-ssh-panel.png)

## VS Code in the Browser

Launch VS Code in the browser from the Environments page by clicking the _Code
Web_ icon.

![Launch an Environment](../assets/launch-env.png)

## JetBrains IDEs in the Browser

If your image includes a JetBrains IDE, you can launch it from the dashboard.
Coder launches JetBrains IDEs in their own windows; be sure to set your browser
to allow popup windows so that you can use your IDE.

![JetBrains Logos](../assets/jetbrains-launcher-icons.png)

> If you need a valid license to run your IDE locally, you'll also need one to
> run it in Coder.

### Manually Installing JetBrains' IDEs

You can also manually install JetBrains' IDEs. After following JetBrains' steps
for installing your IDE, create a symlink, and add it to $PATH.

The symlink names supported by Coder are:

- `clion`
- `datagrip`
- `goland`
- `intellij-idea-ultimate`
- `intellij-idea-community`
- `phpstorm`
- `pycharm`
- `pycharm-community`
- `rider`
- `rubymine`
- `webstorm`

### System Requirements

For the best possible experience, we recommend running the editor in an
environment with the following resources at a minimum:

- 8 GB RAM
- 4 CPU cores

### Known Issues

- Window dragging behavior can misalign with mouse movements
- Popover dialogs do not always appear in the correct location
- Popup windows are missing titles and window controls
- Some theme-based plugins can cause the IDE to render incorrectly
- Some minor rendering artifacts occur during regular usage
