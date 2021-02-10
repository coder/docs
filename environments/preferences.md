---
title: "User Preferences"
description: Learn how to manage your Coder account preferences.
---

The User Preferences area of the Coder UI allows you to manage your account. To
access this area, click on your avatar in the top-right, and click on either
**Account** or your avatar in the drop-down menu.

## Account

The **Account** tab allows you to provide or change:

- Your display name
- Email address
- Username (this is the value that Coder uses throughout the platform, including
  in Dev URLs and the CLI's SSH configuration)
- Your dotfiles URI to personalize your environments
- Your avatar

## Security

The **Security** tab allows you to change your password if you log in using
built-in authentication (that is, you log in by providing an email/password
combination).

> You cannot change the passwords for accounts authenticated via Open ID Connect
> using the Coder platform. However, your password may be changeable within your
> organization's account management system. See your system administrator for
> more information.

## SSH Key

The **SSH Key** page is where you'll find the public key corresponding to the
private key that Coder inserts automatically into your environments. The public
key is useful for services, such as Git, Bitbucket, GitHub, and Gitlab, that you
need to access from your environment.

If necessary, you can regenerate your key. Be sure to provide your updated key
to all of the services you use. Otherwise, they won't work.

## Linked Accounts

The **Linked Accounts** tab allows you to automatically provide your Coder SSH
key to the Git service of your choice. You can then perform the Git actions in
your Coder environment and interact with the service (e.g., push changes).

## Notifications

You can choose to allow Coder to display native **notifications** so that you
can receive necessary alerts even when focused on a different view or page.

Coder issues desktop notifications when you create a new environment or rebuild
an environment.

Please note that:

- You may not receive native notifications when using your browser's private
  browsing mode
- You must enable native notifications for each browser on which you run Coder
  Enterprise

You can check whether notifications are enabled and working by click **Test
Notifications**.
