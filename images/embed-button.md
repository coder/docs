---
title: Embeddable button
description: Learn how to embed an "Open in Coder" Button in Your Repo
---

You can embed an Open in Coder button onto your project's README file or
documentation to provide developers with a one-click way to start contributing.
When a developer clicks on the embedded button, their workspace will use the
image as you've configured it and automatically pull in the repository.

![The Embed Button](../assets/images/embed-1.png)

## Requirements

- You must have Git and SSH installed on your image
- Coder must be [integrated with a supported git provider](../../admin/git.md)
- You must
  [link your Coder account](../../workspaces/preferences.md#linked-accounts)
  to the service of your choice. This step is required for anyone who wants to
  use the button to launch a project using the provided image and repo.

## Create the embedded button's code

Coder can automatically generate the code you need to embed the Open in Coder
button.

1. In the Coder UI, go to **Images**. Find the image you want to use and click
   to open.
1. Underneath the name of the image, click **Embed**.
1. Choose the **Image Tag** and **Git Service** you want to use, and provide
   your **Git Repository URI**.
1. Once you fill in the required fields, Coder generates the code you need in
   Markdown or HTML (you can change the button's display text by modifying the
   Markdown or HTML snippets). Copy the code and paste it into your README.md
   file.

![Create embed button](../assets/images/embed-2.png)
