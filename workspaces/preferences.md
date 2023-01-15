# Preferences

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

> During the linked account process, Coder sends requests directly from your
> local machine's web browser to your Git provider. If your organization
> requires additional authentication (e.g., VPN), you must start this process
> before linking your accounts.
>
> Note that linking your accounts is a one-time process, typically during
> onboarding. Future Git actions within Coder will operate within the Coder
> deployment's network, _not_ the local machine.

## Networking

You can choose the WebRTC protocol used when connecting to your workspace from
the Coder CLI:

- **Auto** (default): uses STUN and falls back to TURN if it's unable to
  establish a peer-to-peer connection
- **TURN**: establishes a connection using an intermediary relay server
- **STUN**: establishes a peer-to-peer connection

## Auto-start

Auto-start allows you to set the time when Coder automatically starts and builds
your workspaces. See [auto-start](autostart.md) for more information.
