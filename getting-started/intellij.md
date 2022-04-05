---
title: IntelliJ
description: Get started with Coder as an IntelliJ user.
---

This article will walk you through getting started with a Coder workspace and a
project that leverages IntelliJ. You'll learn how to:

- Connect Coder to your Git provider;
- Create a workspace;
- Create an IntelliJ project;
- Push your changes to GitHub.

## Prerequisites

This guide assumes that you have a Coder deployment available to you and that
you have the credentials needed to access the deployment.

## Step 1: Log in and connect Coder to your Git provider

You'll log into Coder in this step and connect and authenticate with your Git
provider. This will allow you to do things like pull repositories and push
changes.

1. Navigate to the Coder deployment using the URL provided to you by your site
   manager, and log in.

1. Click on your avatar in the top-right, and select **Account**.

   ![Set account preferences](../assets/getting-started/account-preferences.png)

1. Provide Coder with your SSH key to connect and authenticate to GitHub.

   If your site manager has configured OAuth, go to **Linked Accounts** and
   follow the on-screen instructions to link your GitHub account.

   ![Link GitHub account](../assets/getting-started/linked-accounts.png)

   If your site manager has _not_ configured OAuth, go to **SSH keys**. Copy
   your public SSH key and
   [provide it to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

   ![Add SSH key](../assets/getting-started/ssh-keys.png)

## Step 2: Create your workspace

You will now create the workspace to work on your development project.

1. Return to **Workspaces** using the top navigation bar.

1. Click **New workspace** to launch the workspace-creation dialog.

1. Provide a **Workspace Name**.

1. In the **Image** section, click **Packaged** (this tab contains
   Coder-provided images hosted in a Docker registry). Select **IntelliJ**. This
   will populate the form in the **Import** tab.

1. Under **Workspace providers**, leave the default option (which is
   **built-in**) selected.

1. Expand the **Advanced** section. If the **Run as a container-based virtual
   machine** option is selected, _unselect_ the box. Leave the **CPU**,
   **Memory**, **Disk**, and **GPU** allocations as-is.

1. Scroll to the bottom and click **Create workspace**. The dialog will close,
   allowing you to see the main workspace page. You can track the workspace
   build process using the **Build log**on the right-hand side.

![Create a workspace](../assets/getting-started/create-workspace-intellij.png)

Once your workspace is ready for use, you'll see a chip that says **Running**
next to the name of your workspace.

## Step 3: Create a sample project file in your workspace

Once you've created your workspace, you can start working in Coder. For the
purposes of this article, we'll leverage JetBrains' tutorial on how to
[Create and run your first Java project](https://www.jetbrains.com/help/idea/creating-and-running-your-first-java-application.html).

1. Under **Browser applications**, click **IntelliJ IDEA Community** to open the
   IDE in your browser. Follow the prompts to accept the license agreement and
   determine data sharing permissions.

1. If the welcome screen opens, click **New Project**. Otherwise, open the main
   menu, and select **File** > **New Project**.

1. Under Project SDK, select Download SDK, leave the pre-filled fields as-is,
   and click **Download**.

1. Click **Next**.

1. Click **Next** again since you will not be creating a project from a template

1. Name your project `HelloWorld`, and click **Finish**.

1. In the Project tool window, right-click the **src** folder, then select
   **New** > **Java Class**.

1. In the **Name** field, enter `com.example.helloworld.HelloWorld` and click
   **OK**. The IDE will create the `com.example.helloworld` package and the
   `HelloWorld` class.

1. Update your code so that it looks like the following:

   ```java
   package com.example.helloworld;

   public class HelloWorld {
       public static void main(String[] args) {
           System.out.println("Hello, world!");
       }
   }
   ```

1. Click the **green triangle** to the left of your code. In the pop-up that
   appears, select **Run 'HelloWorld.main()'**. IntelliJ will begin compiling
   your code.

When IntelliJ is done compiling your code, it opens a new pane at the bottom
that displays the result of running your code.

## Step 5: Push your repo to GitHub

The following steps show you how to push your app to a newly created GitHub
repo.

1. Log in to GitHub and navigate to
   [Create a new repository](https://github.com/new).

1. Provide a **repository name** and click **Create repository**.

1. Return to your workspace, and click **Terminal** at the bottom.

1. Run the following to turn your directory into a Git repository and commit
   your initial changes:

   ```console
   cd ..
   git init <nameOfDirectory>
   cd <nameOfDirectory>
   git add -A
   git commit -am "Initial commit"
   ```

1. Run the following in your terminal to add a remote to your GitHub repo,
   change the primary branch name to `main`, and push the contents to your newly
   created repo:

   ```console
   git remote add origin git@github.com:<username>/<repoName>.git
   git branch -M main
   git push origin main
   ```

1. Within the IDE window (near the top), you'll be prompted to log in to GitHub
   by providing your username and password/personal access token.

1. Next, Code Web will display an alert that says the GitHub extension wants to
   sign in; click **Allow** to proceed.

1. In the subsequent window, click **Continue** to authorize Visual Studio Code
   to access GitHub.

   At this point, the contents of your repo should be pushed to GitHub.
