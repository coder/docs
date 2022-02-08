---
title: Authentication management
description: Learn how to manage Coder authentication.
---

By default, Coder enables **built-in authentication**, though you can change
this if desired.

To do so, go to **Manage** > **Users**. Find the user whose authentication type
you want to change, and use the **Auth Type** to toggle between **Built-In** and
**OpenID Connect**.

If you opt for **OpenID Connect**, you'll need to provide additional
configuration steps, which are detailed in the subsequent sections of this
article.

## Set up OIDC authentication

To set up OIDC authentication, you'll first need to register a Coder application
with your OIDC provider. During this process, you'll be asked to provide a
domain name for the OIDC token callback; use
`https://coder.my-company.com/oidc/callback`.

Once you've registered a Coder application with your OIDC provider, you'll need
to return to Coder and complete the setup process. Under **Admin** > **Manage** >
**Authentication**, make sure that you've selected **OpenID Connect** as the
authentication type. Then, provide the following parameters:

- **Client ID**: The client ID for the Coder application you registered with the
  OIDC provider
- **Client Secret**: The secret assigned to the Coder application you registered
  with the OIDC provider
- **Issuer** (e.g., `https://my-idp.com/realm/my-org`): The URL where Coder can
  find your OIDC provider's configuration document

> If you do not have values for any of these parameters, you can obtain them
> from your OIDC provider.

There are several additional configuration parameters that may be of interest to
you:

- **Enable Access Tokens:** Toggle **On** if you'd like to allow users to fetch
  tokens from `https://<yourDomain>/api/v0/users/me/oidc-access-token`
- **Additional Scopes:** Specify any scopes (beyond the default) that you would
  like Coder to request during the login process
- **Disable built-in authentication:** Choose whether Coder removes the ability
  to log in with an email/password option when you've enabled OIDC
  authentication

### Disable built-in authentication

You can disable built-in authentication as an option for accessing Coder if you
have OIDC configured.

![Login page with built-in authentication
disabled](../../assets/admin/disable-built-in-auth.png)

[Site managers](users/user-roles#site-manager-permissions) can still use
built-in authentication. To view this option on the login page, add the
following query parameter to the URL you use to access your Coder deployment:

```text
/login?showAllAuthenticationTypes=1
```
