---
title: OpenID Connect with Google
description: Learn how to use Google SSO with Coder.
---

This article walks you through setting up single sign-on to Coder using Google.

Configuring [Coder's OpenID
Connect](../../admin/access-control/index.md#openid-connect) feature requires
you to provide three pieces of information from Okta:

- Client ID
- Client Secret
- Issuer

This guide will show you how to set up an app on Okta and obtain the information
you need to provide to Coder.

> Note: this guide assumes you've enabled the Identity Platform in your Google
> Cloud account. If not already
> completed, [see here for setup documentation](https://cloud.google.com/identity-platform/docs/web/oidc).

## Step 1: Create OAuth consent screen

1. Navigate to <https://console.cloud.google.com/>

1. From the dashboard, to go **APIs & Services**

1. Navigate to **OAuth consent screen** and set the following fields:

- App name
- User support email
- App domain(s)
- Authorizations domains (e.g. <coder.your-domain.com>)

1. Click **Save**

## Step 2: Create OAuth Client ID

1. Navigate to **Credentials** and click **Create Credentials**

1. Select **OAuth Client ID**

1. Choose **Web Application**

1. Fill out the following fields:

- Name
- Authorized redirect URIs (e.g. <coder.your-domain.com/oidc/callback>)

1. Click **Create**

## Step 3: Input OIDC credentials into Coder

Now that you've registered the Client ID for Coder, you can now input the
**Client ID**, **Client Secret**, and **Issuer** into Coder.

1. Navigate to your Coder deployment

1. Go to **Manage** > **Admin** > **Authentication**

1. Toggle to **OpenID Connect**

1. Input the **Client ID** & **Client Secret** values from Google

1. Input the **Issuer**, which is `accounts.google.com`.

You can now use Google as an SSO provider with Coder.
