---
title: OpenID Connect with Azure AD
description: Guidance on how to register the application for Azure's Active Directory SSO.
---

Configuring [Coder's OpenID Connect](/docs/admin/access-control#openid-connect) requires 3 pieces of 
information: Client ID, Client Secret, and Issuer.  Azure's Active Directory has so many options that
trying to identify these things is like finding a needle in a haystack. 

# App Registration

On the search bar at the top, simply type "App registrations" and it will bring you to the easiest
starting point. 

Click on the `New registration` button to get started.

## New registration

Give it a name

Select the proper tenancy, default should work for testing but fancier setups may need multi-tenancy.

Provide your OIDC Callback URL such as: `https://coder.coderworkshop.com/oidc/callback`

Click `Create`. 

## Finding the needles

### Client ID

This one is pretty obvious: 

1.  Under "Essentials", you'll find `Application (client) ID` which is the `Client ID`

### Client Secret

The client secret hast to be created.

1.  Under "Certificates and Secrets", you'll find `Client secrets` 
1.  Seeing as we just created this, there are unlikely to be any client secrets yet.
1.  Create a new client secret with a reasonable Description and Expiration date.
1.  Create a calendar notification to make a new client secret before this one expires
1.  Copy the `Value` field out of the newly created secret (Not the Secret ID).
1.  Paste it into the `Client Secret` field in Coder.

### Issuer

At the top of the Overview page, click the button for "Endpoints". In the flyout, find
`OpenID Connect metadata document` and put that in the issuer. 

Replace the `login.microsoft.com` part with `sts.windows.net`, keep the GUID, and delete the rest after the slash.

For example: `https://sts.windows.net/110f0c0f-cd76-4717-a6f8-4eea3d0f8109/`

The good news is that the error message will tell you what it "got" and what it "expected" so you can
make the value in the configuration match what it "got" unless it is showing a very different URL.

