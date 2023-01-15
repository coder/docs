# GitHub OAuth integration

When configuring the OAuth integration between Coder and GitHub, you may
encounter the following error:

![Failed to link](../../assets/guides/troubleshooting/oauth-error.png)

## Why this happens

This error occurs when your Coder public key has been uploaded to your GitHub
profile; when you attempt to link Coder and GitHub, the OAuth integration
attempts to add your public key again to GitHub.

## Solution

1. [Remove your Coder public key](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/reviewing-your-ssh-keys)
   from your GitHub account.

1. In Coder, navigate to **Account** > **Linked Accounts** and click **Link Your
   GitHub Account**.

1. If successful, you will be re-directed back to the **Account** page. There
   will be a message in the bottom right corner that says:

   ```console
   Successfully linked to GitHub account <your-GitHub-username>
   ```

If the steps above do not fix the problem, the error may be related to the
GitHub configuration values set using Coder's **Admin** panel. Site managers can
view and update these values at **Manage** > **Admin** > **Git OAuth**.

If this doesn't resolve the issue, please
[contact us](https://coder.com/contact) for further support.
