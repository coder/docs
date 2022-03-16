---
title: "Preferences"
description: Learn how to manage your Coder account preferences.
---

The **User Preferences** area of the Coder UI allows you to manage your account.

To access **User Preferences**, click on your avatar in the top-right, then
click on either **Account** or your avatar in the drop-down menu.

## Account

The **Account** tab allows you to provide or change:

- Your avatar
- Your display name
- Email address
- Username (this is the value that Coder uses throughout the platform, including
  dev URLs and the CLI's SSH configuration)
- Shell (this is the command Coder runs when starting a terminal)
- Your dotfiles URI to personalize your workspaces

## Appearance

To use Coder's dark theme, enable it by selecting **Dark Theme**. Coder uses its
light theme by default.

## Security

The **Security** tab allows you to change your password if you log in using
built-in authentication (that is, you log in by providing an email/password
combination).

> You cannot change the passwords for accounts authenticated via Open ID Connect
> using the Coder platform. However, your password may be changeable within your
> organization's account management system. See your system administrator for
> more information.

## SSH keys

The **SSH Keys** page is where you'll find the public SSH key corresponding to
the private key that Coder inserts automatically into your workspaces. The
public key is useful for services, such as Git, Azure Repos, Bitbucket, GitHub,
and GitLab, that you need to access from your workspace.

If necessary, you can regenerate your key. Be sure to provide your updated key
to all of the services you use. Otherwise, they won't work.

## Linked accounts

The **Linked Accounts** tab allows you to automatically provide your Coder SSH
public key to the Git service of your choice. You can then perform the Git
actions in your Coder workspace and interact with the service (e.g., push
changes). Your administrator must configure OAuth for this feature to work.

> The Linked Account process sends the request directly from your local machine's 
> web browser to your Git Provider, if your orgization requires additional 
> authentication like VPN, that will have to be started before running this process.
> Note that this is a one-time user configuration e.g., like at onboarding, and 
> future git actions within Coder will operate within the Coder deployment's 
> network and not the local machine.

## Notifications

You can choose to allow Coder to display native **notifications** so that you
can receive necessary alerts even when focused on a different view or page.

Coder issues desktop notifications when you create a new workspace or rebuild an
workspace.

Please note that:

- You may not receive native notifications when using your browser's private
  browsing mode
- You must enable native notifications for each browser on which you run Coder
  Enterprise

You can check whether notifications are enabled and working by click **Test**.

## Auto-start

Auto-start allows you to set the time when Coder automatically starts and builds
your workspaces. See [auto-start](autostart.md) for more information.
