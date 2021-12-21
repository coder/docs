---
title: "Extensions"
description: Learn how to add and use VS Code extensions with your workspace.
---

There are several methods to add and use VS Code extensions with a Coder workspace.


1. [Public extensions marketplaces](vs-code-extensions.md#public-extensions-marketplaces) with Code Web (code-server)
1. [Add to custom images](vs-code-extensions.md#custom-images)
1. [The code-server command line](vs-code-extensions.md#the-code-server-command-line)
1. [local VS Code with SSH](vs-code-extensions.md#local-vs-code-with-ssh)

## Public extensions marketplaces

You can manually add an extension from within the Code Web IDE.  Optionally you can [administratively configure which marketplace to use.](../admin/workspace-management/extensions.md#the-extension-marketplace)

This can be Coder's public marketplace, Eclipse Open VSX's public marketplace, or the Eclipse open VSX local marketplace.  Legally, Code Web (code-server) cannot connect to Microsoft's public marketplace.

![Code Web Extensions](../assets/workspaces/code-web-extensions.png)

## Custom images

You can add extensions to a custom image and install them either through Code Web or in the workspace's terminal.

1. Download the extension(s) from the Microsoft public marketplace.
![Code Web Extensions](../assets/workspaces/microsoft-public-marketplace-download-vsix.png)
1. Include the vsix extension files in the same folder with your Dockerfile.
![Add vsix files to Dockerfile folder](../assets/workspaces/vsix-to-dockerfile.png)
1. In the Dockerfile, make a folder with a command and the copy the vsix files into it.
![Make folder and copy vsix files within Dockerfile](../assets/workspaces/add-vsix-inside-dockerfile.png)
1. Add a configure script in the folder with your Dockerfile and run the code-server command to install the extension
![Make folder and copy vsix files within Dockerfile](../assets/workspaces/extension-installed-configure-script.png)
1. Build the custom image and upload to the container registry connected to Coder and import the custom image into Coder
1. Build a workspace from the custom image
![Workspace built and extension installed at configure step](../assets/workspaces/workspace-build-extension-installed.png)

## The code-server command-line

You can use the code-server executable in a Coder workspace to install an extension.

1. [Install from a marketplace](vs-code-extensions.md#install-from-a-marketplace-at-the-command-line)
1. [Install from a vsix file](vs-code-extensions.md#install-from-a-vsix-file-at-the-command-line)

## Install from a marketplace at the command line

Coder's public marketplace
```text
SERVICE_URL=https://extensions.coder.com/api ITEM_URL=https://extensions.coder.com/item /var/tmp/coder/code-server/bin/code-server --install-extension ms-python.python
```

Open VSIX's public marketplace
```text
SERVICE_URL=https://open-vsx.org/vscode/gallery ITEM_URL=https://open-vsx.org/vscode/item /var/tmp/coder/code-server/bin/code-server --install-extension ms-python.python  
```

## Install from a vsix file at the command line

```text
/var/tmp/coder/code-server/bin/code-server --install-extension /vsix/ms-python.python-2020.10.332292344.vsix
```

> You can alternatively run these commands within a [template](./workspace-templates/templates.md), [configure script](../images/configure.md) or [personalize script](./personalization.md#personalize).

## Local VS Code with SSH

You use a local VS Code IDE and [configure with Coder via SSH](./editors.md#vs-code-remote-ssh) to add extensions from Microsoft's extension marketplace.

![Microsoft extension marketplace](../assets/workspaces/local-vs-code-marketplace.png)