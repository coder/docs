---
title: "Editors and IDEs"
description:
  Learn how to connect your favorite editors and IDEs to your remote workspace.
---

There are five primary ways you can connect an IDE to your Coder workspace:

1. [VS Code remote SSH](editors.md#vs-code-remote-ssh) with local VS Code
1. [VS Code in the browser](editors.md#vs-code-in-the-browser) with code-server
1. [JetBrains in the browser](editors.md#jetbrains-ides-in-the-browser) with
   JetBrains Projector
1. [JetBrains' Code With Me](editors.md#code-with-me)
1. [RStudio](editors.md#rstudio)
1. _Any_ local editor with
   [1-way file synchronization](../cli/file-sync.md#one-way-file-sync) or
   [2-way file synchronization over SSH](../cli/file-sync.md#two-way-file-sync)

## VS Code remote SSH

Once you've [set up SSH access to Coder](./ssh.md), you can work on projects
from your local VS Code, connected to your Coder workspace for compute, etc.

1. Open VS Code locally.
1. Make sure that you've installed
   [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)
   extension
1. In VS Code's left-hand nav bar, click **Remote Explorer** and right-click on
   a workspace to connect

![VS Code Remote Explorer](../assets/workspaces/vscode-remote-ssh-panel.png)

## VS Code in the browser

Launch VS Code in the browser from the workspaces page by clicking the _Code
Web_ icon.

![Launch a workspace](../assets/workspaces/launch-workspace.png)

## JetBrains IDEs in the browser

If your image
[includes a JetBrains IDE](../admin/workspace-management/installing-jetbrains.md),
you can launch it from the dashboard. Coder launches JetBrains IDEs in their own
windows; be sure to set your browser to allow popup windows so that you can use
your IDE.

![JetBrains logos](../assets/guides/deployments/applications.png)

> If you need a valid license to run your IDE locally, you'll also need one to
> run it in Coder.

### Manually installing JetBrains' IDEs

You can also manually install JetBrains' IDEs. After following JetBrains' steps
for installing your IDE (make sure that you install the IDE to your home
directory), create a symlink, and add it to `PATH`.

The symlink names supported by Coder are:

- `clion`
- `datagrip`
- `dataspell`
- `goland`
- `intellij-idea-ultimate`
- `intellij-idea-community`
- `phpstorm`
- `pycharm`
- `pycharm-community`
- `rider`
- `rubymine`
- `studio` (Android Studio)
- `webstorm`

### System requirements

For the best possible experience, we recommend running the editor in an
workspace with the following resources at a minimum:

- 8 GB RAM
- 4 CPU cores

### Known issues

- Window dragging behavior can misalign with mouse movements
- Popover dialogs do not always appear in the correct location
- Popup windows are missing titles and window controls
- Some theme-based plugins can cause the IDE to render incorrectly
- Some minor rendering artifacts occur during regular usage

## Code With Me

[JetBrains' Code With Me](https://www.jetbrains.com/code-with-me/) allows you to
collaborate with others in real-time on your project and enables pair
programming.

> You must have a
> [JetBrains IDE installed](../admin/workspace-management/installing-jetbrains.md)
> in your [image](../images/index.md) to use Code With Me.

### Getting started

To set up a Code With Me session:

1. The host creates a session and shares the information needed to join the
   session with other participants.
1. The participants use the information provided by the host to join the session
   and request access.
1. The host accepts the participants' request to join the session created by the
   host.

#### Step 1: Start and host a session

To create and host a Code With Me session:

1. Log in to Coder.

1. Under **Applications**, launch the JetBrains IDE (e.g., GoLand) of your
   choice.

   ![Launch IDE](../assets/workspaces/code-with-me-1.png)

1. Click the **Code With Me** icon at the top of your IDE.

   ![Code With Me icon](../assets/workspaces/code-with-me-2.png)

1. Select **Enable Access and Copy Invitation Link...**.

   ![Enable access and copy link](../assets/workspaces/code-with-me-3.png)

1. Confirm and accept the Terms of Use.

1. Set the permissions for new guests to **Full access** and uncheck the
   **Automatically start voice call** feature. Click **Enable Access**.

   ![Set permissions](../assets/workspaces/code-with-me-4.png)

1. Once you've enabled access, JetBrains copies the link you must share with
   participants to your clipboard. Send this link to those with whom you'd like
   to collaborate.

   You can recopy this link at any time by clicking the **Code With Me icon**
   and choosing **Copy Invitation Link...**.

   ![Link confirmation](../assets/workspaces/code-with-me-5.png)

#### Step 2: Request to join the session

If you've received a link to join a Code With Me session as a participant:

1. Copy the Code With Me session link that you were provided, and paste it into
   your web browser. You'll be directed to a webpage with further instructions.

1. On the instructions page to which you were directed, copy the code snippet
   and run it in the terminal.

   ![Run join command in terminal](../assets/workspaces/code-with-me-6.png)

1. Confirm and accept the User Agreement.

1. You'll be shown a **security code**. Verify with the host of your session
   that they see the same code.

   ![Security code verification](../assets/workspaces/code-with-me-7.png)

1. Wait for your host to accept your request to join; when they do, your
   JetBrains IDE will launch automatically.

   ![New JetBrains IDE](../assets/workspaces/code-with-me-8.png)

#### Step 3: Accept the request to the join

If you're the host of the session, you'll see a request that the other
participant wants to join your project, the permissions you've granted to the
other user, and a security code.

![Security code verification for host](../assets/workspaces/code-with-me-9.png)

Verify that the security code you see matches the one shown to your
participants. If they do, click **Accept** to proceed.

At this point, you'll be able to share your project and work with your partner
in real-time.

## RStudio

Coder supports [RStudio](rstudio.com). To create a workspace that lets you use
RStudio:

1. Create a [custom image](../images/writing.md) with RStudio installed,
   `rserver` and `pgrep` in `PATH`, and RStudio configured to run on the default
   port (`8787`).

   To do this, you can refer to the sample Dockerfile below, which installs
   RStudio Server Open Source and creates a Unix user to log in with username
   `coder` and password `rstudio`.

   ```Dockerfile
   FROM ubuntu:20.04

   USER root

   # Install dependencies
   RUN apt-get update && \
   DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
   bash \
   sudo \
   git \
   ssh \
   locales \
   wget \
   r-base \
   gdebi-core

   # Install RStudio
   RUN wget
   https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
   && \
   gdebi --non-interactive rstudio-server-1.4.1717-amd64.deb

   # Create coder user
   RUN useradd coder \
   --create-home \
   --shell=/bin/bash \
   --uid=1000 \
   --user-group && \
   echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

   # Ensure rstudio files can be written to by the coder user.
   RUN chown -R coder:coder /var/lib/rstudio-server
   RUN echo "server-pid-file=/tmp/rstudio-server.pid" >> /etc/rstudio/rserver.conf
   RUN echo "server-data-dir=/tmp/rstudio" >> /etc/rstudio/rserver.conf

   # Assign password "rstudio" to coder user.
   RUN echo 'coder:rstudio' | chpasswd

   # Assign locale
   RUN locale-gen en_US.UTF-8

   # Run as coder user
   USER coder

   # Add RStudio to path
   ENV PATH /usr/lib/rstudio-server/bin:${PATH}
   ```

1. [Create a workspace](getting-started.md#2-create-a-workspace) using the image
   you created in the previous step.

1. At this point, you can go to **Applications** to launch RStudio.

   ![Applications with RStudio launcher](../assets/workspaces/rstudio.png)

   Sign in using the Unix user (whose username and password you defined in your
   image).

   > RStudio may take a few additional seconds to start launch after the
   > workspace is built.
   >
   > All RStudio data is stored in the home directory associated with the user
   > you sign in as
