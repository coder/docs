---
title: Coder for Docker
description: Get started with Coder for Docker as a developer.
---

FORTHCOMING

## Prerequisites

Please [install Coder for Docker](../setup/docker.md) before proceeding.

## Step 1: Log in and configure Coder

In this step, you'll log into Coder and connect and authenticate with your Git
provider. This will allow you to do things like pull repositories and push
changes.

1. Navigate to the Coder deployment using the URL provided to you during the
   Coder for Docker installation process, and log in.

1. Click on your avatar in the top-right, and select **Account**.

   ![Set account preferences](../assets/getting-started/account-preferences.png)]

1. Provide Coder with your SSH key to connect and authenticate to GitHub.

   If your site manager has configured OAuth, go to **Linked Accounts** and
   follow the on-screen instructions to link your GitHub account.

   ![Link GitHub account](../assets/getting-started/linked-accounts.png)

   If your site manager has _not_ configured OAuth, go to **SSH keys**. Copy
   your public SSH key and
   [provide it to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

   ![Add SSH key](../assets/getting-started/ssh-keys.png)

## Step 2: Create your workspace

You will now create the workspace where you'll work on your development project.

1. Return to **Workspaces** using the top navigation bar.

1. Click **New workspace** to launch the workspace-creation dialog.

1. Provide a **Workspace Name**.

1. In the **Image** section, click **Packaged** (this tab contains
   Coder-provided images hosted in a Docker registry). Select **Ubuntu**. This
   will populate the form in the **Import** tab.

1. Under **Workspace providers**, leave the default option (which is
   **built-in**) selected.

1. Scroll to the bottom, and click **Create workspace**. The dialog will close,
   allowing you to see the main workspace page. You can track the workspace
   build process using the **Build log** on the right-hand side.

![Create a workspace](../assets/getting-started/create-workspace.png)

Once your workspace is ready for use, you'll see a chip that says **Running**
next to the name of your workspace.

## Step 3: Terminal

Click the **Terminal** icon to launch a console window for your workspace in a
new browser tab.

Click **Code Web** to launch code-server; code-server is Coder's port of
Microsoft's VS Code to the web.
