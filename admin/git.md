---
title: Git integration
description:
  Learn how to integrate with a Git provider to authenticate workspaces.
---

The Git Integration allows your developers to connect their Coder accounts to
their accounts with the Git repository service of choice.

## Support

Coder integrates with the following service providers for authentication and
[user key management](../workspaces/preferences#linked-accounts):

- GitHub (both GitHub.com and GitHub Enterprise)
- GitLab (both GitLab.com and self-hosted GitLab)
- Bitbucket Server (_not_ Bitbucket Cloud; the Cloud API <a
  href="https://jira.atlassian.com/browse/BCLOUD-17762" target="_blank"
  rel="noreferrer noopener">doesn't support</a> managing SSH keys for users via
  OAuth)

> Coder supports integration with
> [Azure Repos (Azure DevOps) via SSH](https://docs.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate?view=azure-devops#step-2--add-the-public-key-to-azure-devops-servicestfs),
> though we do not currently support OAuth capabilities. Developers can find
> their public SSH keys under [preferences](../workspaces/preferences.md).

Linking your Coder account with a git service provider is _not_ required.
Instead, you can use Visual Studio Code with git, the command-line tool, and we
expect this combination to work with most hosting software or services. However,
Coder doesn't test these and cannot provide recommendations or support.

> Ensure that your Git provider supports the keygen algorithm that Coder uses;
> you can choose the algorithm in **Manage** > **Admin** > **Security** >
> **SSH**.

![Configure Git Integration](../assets/admin/git-admin.png)

## Configuring OAuth

Before developers can link their accounts, you (or another site manager) must
create an OAuth application with the appropriate providers. You can create as
many OAuth applications as necessary.

1. Log into Coder as a site manager, and go to **Manage** > **Admin** > **Git
   OAuth**.
1. Click **Add provider**.
1. Select your **Provider** (e.g., GitHub, GitLab, or Bitbucket Server).
1. Create an OAuth application with your Git provider and provide Coder with the
   requested details (the parameters required vary based on your Git provider).
   See the following sections for additional guidance.

### GitHub

When <a
href="https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/"
target="_blank" rel="noreferrer noopener">creating an OAuth app</a>, GitHub will
ask you for the following Coder parameters:

- **Homepage URL**: Set to `[your-coder-domain]` (e.g.
  `https://coder.domain.com`)
- **User Authorization Callback URL**: Set to
  `[your-coder-domain]/oauth/callback` (e.g.
  `https://coder.domain.com/oauth/callback`)

Then, in Coder, provide a **Name** for your app, your **URL**, **Client ID**,
and **Client Secret** to Coder. You can also provide an optional
**Description**.

When done, click **Save**.

### GitLab

When <a href="https://docs.gitlab.com/ee/integration/oauth_provider.html"
target="_blank" rel="noreferrer noopener">setting up OAuth with GitLab</a>,
you'll have to provide the following during setup:

- **Redirect URI**: Set to `[your-coder-domain]/oauth/callback` (e.g.
  `https://coder.domain.com/oauth/callback`)

You can modify the settings for your application afterward. Make sure you've
enabled the following:

- **Confidential**: Check this option
- **API** (scope): Check this option

Then, in Coder, provide a **Name** for your app, your **URL**, **Application
ID**, and **Client Secret** to Coder. You can also provide an optional
**Description**.

When done, click **Save**.

### Bitbucket Server

On your Bitbucket Server, go to **Administration** > **Application Links**.

Create a new **Application Link**, setting the **Application URL** as
`[your-coder-domain]` (e.g. `https://coder.domain.com`). If you receive a **No
response received** error, click **Continue** to ignore it.

For your newly created Application Link, provide the following values as your
**Incoming Authentication** properties:

- **Consumer Key**: `Coder` (or the value of `CODERD_BITBUCKET_CONSUMER_KEY`)
- **Consumer Name**: `Coder`
- **Public Key**: Your public key (available from the Coder Admin Configuration
  page)

Then, in Coder, provide a **Name** for your app, your **URL**, and, optionally,
a **Description**.

When done, click **Save**.

> 💡 By default, Coder sets the Bitbucket Consumer Key to `Coder`. This can
> cause issues when attempting to link multiple Coder instances to a single
> Bitbucket server. In this case, you can override the Bitbucket Consumer Key by
> setting the environment variable `CODERD_BITBUCKET_CONSUMER_KEY` to a unique
> value for each Coder deployment. Here's an example of how to set this in your
> Helm values:
>
> ```yaml
> coderd:
>   [...]
>   extraEnvs:
>     [...]
>     - name: CODERD_BITBUCKET_CONSUMER_KEY
>       value: ""
> ```

### Built-in GitHub Integration (VS Code)

Alternatively, users can VS Code's
[built-in GitHub integration](https://code.visualstudio.com/docs/sourcecontrol/github)
in order to clone repositories within VS Code Remote and code-server. This uses
a GitHub token to authenticate instead of SSH keys.

To cache the token within the workspace, users can run the following command.
This can also be added to a [configure script](../images/configure.md):

```sh
git config --global credential.helper store
```
