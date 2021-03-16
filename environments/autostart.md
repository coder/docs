---
title: "Autostart"
description: Learn how to configure automated environment rebuilds.
---

Autostart allows you to set environments to turn on automatically at a
predetermined time.

## Background

Coder automatically turns off unused environments after 8 hours to help you save
on cloud usage costs. Turning off environments, however, requires you to turn
them on manually the next day. Autostart can help eliminate this manual process.

Autostart also allows you to configure automated environment rebuilds at a time
that best suits your workflow. You can now expect your environments to be ready
for you at the start of each workday.

## Criteria for Autostart

Your environment must meet the following criteria for you to use autostart:

1. You've [set the autostart time and selected
   environments](#enabling-autostart) to be started automatically at that time.

1. Your environments are off at the autostart time (autostart won't work if your
   environments are on to prevent the possibility of triggering a rebuild while
   you're working).

2. Your environment must be active. We define *inactive* environments as those
   that haven't been opened in five days or more.

### Caveat: Trigger Time

Coder may *trigger* autostart up to five minutes before your scheduled time if
your environments satisfy the autostart requirements. This is to make sure that
your environments are ready by your scheduled time.

## Enabling Autostart

1. Click on your avatar in the top-right and select **Account** in the drop-down
   menu.

2. Select the **Autostart** tab and set your desired autostart time.

    ![Set autostart time](../assets/set_autostart_time.png)

3. Select the environments for which you want to enable autostart.

    ![Select environments to
    autostart](../assets/autostart_save_preferences.png)

4. Save.

> When creating a new environment, you can set it to autostart at that time. To
> do so, make sure you check the box enabling **Automatically turn this
> environment on....**
