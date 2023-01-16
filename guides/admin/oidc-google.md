# OpenID Connect with Google

This article walks you through setting up single sign-on to Coder using Google.

Configuring
[Coder's OpenID Connect](../../admin/access-control/index.md#openid-connect)
feature requires you to provide three pieces of information from Google:

- Client ID
- Client Secret
- Issuer

This guide will show you how to set up an app on Google and obtain the
information you need to provide to Coder.

## Prerequisites

Before proceeding, please ensure that you've
[enabled and configured the Identity Platform](https://cloud.google.com/identity-platform/docs/web/oidc)
for your Google Cloud account.

## Step 1: Create the OAuth consent screen

1. Navigate to your [GCP console](https://console.cloud.google.com).

1. Go to **APIs & Services** > **OAuth consent screen**. Create a new app or
   edit an existing app, setting the following fields:

   - **App name**
   - **User support email**
   - App domains (at minimum, you must provide the **Application home page**)
   - Authorized domains (e.g. `coder.your-domain.com`)

1. Click **Save and continue** to proceed.

## Step 2: Create the OAuth Client

1. Under **APIs & Services**, go to **Credentials**.

1. Click **Create Credentials** and select **OAuth Client ID**.

1. When prompted for your **Application type**, choose **Web Application**.

1. Provide a **Name** for your application.

1. Under **Authorized redirect URIs**, click **Add URI**, and provide your URI
   (e.g. `coder.your-domain.com/oidc/callback`).

1. Click **Create**. Google shows you both your **Client ID** and **Client
   Secret**; copy both values and save them, since you'll need to provide these
   Coder.

## Step 3: Provide the OIDC credentials to Coder

Now that you've registered an app, you can provide the relevant **Client ID**,
**Client Secret**, and **Issuer** to Coder.

1. Log into Coder, and go to **Manage** > **Admin** > **Authentication**.

1. Toggle the top-most field to **OpenID Connect**.

1. Provide the **Client ID** and **Client Secret** supplied by Google.

1. For the **Issuer**, provide `https://accounts.google.com`.

1. For **Additional Scopes**, you can leave this value blank.

1. Click **Save preferences**.

You can now use Google as an SSO provider with Coder.

## Optional: Enable token refresh and redirect options

If you'd like to enable session token refresh and define redirect options, set
the following values in Coder's
[Helm chart and update your deployment](helm-charts.md):

```yaml
oidc:
  enableRefresh: true
  redirectOptions: { access_type: offline, prompt: consent }
```
