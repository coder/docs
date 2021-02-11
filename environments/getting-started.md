---
title: "Getting Started"
description: "Learn how to develop in an environment."
---

## 1. Import an Image

Ensure you've [imported an Image](../images/importing.md) for your
[Environment](index.md) to use.

## 2. Create an Environment

If this is your first time using Coder, you'll see a **Create Environment**
button in the middle of your screen; otherwise, you'll see a list of your
existing environments. Click the **New Environment** button.

![Create an Environment](../assets/create-env.png)

1. Enter a friendly name for your environment, and choose an
   [Image](../images/index.md) to use.

1. If you want your environment to turn on at a specific time automatically,
   toggle **Autostart** to **Yes**. You can set the autostart time in [User
   Preferences](preferences.md#autostart). Please note that Coder automatically
   disables autostart if your environment has been inactive for more than three
   days.

1. Select the **Workspace Provider** and the **Namespace** where your
   environment will be located. We recommend selecting the workspace provider
   closest to you to minimize the latency you encounter when using Coder.

2. Click **Create** to proceed.

Coder redirects you to an overview page for your environment during the build
process. Learn more about the Environment [creation
parameters](./environment-params.md).

Your environment persists in the home directory, updates to new versions of the
image, and runs custom configuration on startup. Learn about the [environment
lifecycle](lifecycle.md).

### Advanced

Coder provides advanced settings that allow you to customize your environment.
You can choose to run your environment as a [Container-based Virtual
Machine](cvms.md), specifying the resources Coder should allocate.

> By default, Coder allocates resources (CPU Cores, Memory, and Disk Space)
> based on the parent image.
>
> Coder displays a warning if you choose your resource settings and they're less
> than the image-recommended default, but you can still create the environment.

## 3. Start Coding

Once you've created an environment, it's time to hop in. Read more about how to
[connect your favorite Editor or IDE](./editors.md) with your new environment!

![Start Coding](../assets/applications.png)

> [Integrate with Git](./personalization#git-integration) to automatically have
> your SSH key injected into Environments.
