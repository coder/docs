---
title: "Autostart"
description: Learn how to configure automated environment rebuilds.
---

Coder [automatically turns off idle
environments](../admin/environment-management/shutdown.md) to help manage
resource expenditure. Typically, this means environments turn off overnight and
remain offline until a rebuild is requested. With Autostart, you can request
automated rebuilds at a time that suits your workflow. You can expect your
environments to be ready for you at the start of each workday.

## Criteria for Autostart

Your environment must be:

- Active (*Active* environments are those that have been opened in the last four
  days)
- Off (Autostart doesn't work when environments are *on* to prevent the
  triggering of a rebuild while you're working)

Coder may trigger Autostart up to 5 minutes before your scheduled time to ensure
all queued environments are ready on time.

## Enabling Autostart

1. Click on your avatar in the top-right and select **Account** in the drop-down
   menu.

1. Select the **Autostart** tab and set your desired Autostart time.

    ![Set Autostart time](../assets/set_autostart_time.png)

1. Select the environments for which you want to enable Autostart and save.

    ![Select environments to
    Autostart](../assets/autostart_save_preferences.png)

### Enabling Autostart for New Environments

When creating a new environment, you may enable Autostart by checking the box
labeled **Automatically turn this environment on at (HH:MM)** (where HH:MM is
your configured time).

![Enable Autostart with New Environment](../assets/enable-autostart.png)
