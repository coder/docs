---
title: "Dev URLs"
description: Learn how to configure dev URL support for a Coder deployment.
---

Developer (Dev) URLs allow users to access the ports of services they develop
within their workspace. However, before individual developers can set up dev
URLs, an administrator must configure and enable dev URL usage.

## Before you proceed

You must own a wildcard DNS record for your custom domain name to enable and use
dev URLs with Coder.

## Enabling the use of dev URLs

[Dev URLs](../workspaces/devurls.md) is an opt-in feature. To enable dev URLs in
your cluster, you'll need to set `devurls.host` to a wildcard domain pointing to
your ingress controller:

```shell
helm upgrade coder coder/coder --set devurlsHost="*.my-custom-domain.io"
```

## Setting dev URL access permissions

Once you've enabled dev URLs for users, you can set the **maximum access
level**. To do so, go to **Manage** > **Admin**. On the **Infrastructure** tab,
scroll down to **Dev URL Access Permissions**.

<table>
  <tr>
    <th>Maximum access level</th>
    <th>Description</th>
  </tr>
  <tr>
    <th>Public</th>
    <td>Accessible by anyone with access to the
    network your cluster is on</td>
  </tr>
  <tr>
    <th>Authenticated</th>
    <td>Accessible by any authenticated Coder user</td>
  </tr>
  <tr>
    <th>Organization</th>
    <td>Accessible by anyone in the user's organization</td>
  </tr>
  <tr>
    <th>Private</th>
    <td>Accessible only by the user</td>
  </tr>
</table>

![Setting dev URL permissions](../assets/admin/admin-devurl-permissions.png)

You can set the maximum access level, but developers may choose to restrict
access further.

For example, if you set the maximum access level as **Authenticated**, then any
dev URLs created for workspaces in your Coder deployment will be accessible to
any authenticated Coder user.

The developer, however, can choose to set a stricter permission level (e.g.,
allowing only those in their organization to use the dev URL). Developers cannot
choose a more permissive option.

## Authentication with apps requiring a single callback URL

If you're using GitHub credentials to sign in to an application, and your GitHub
OAuth app has the authorization callback URL set to `localhost`, you will need
to work around the fact that GitHub enforces a single callback URL (since each
workspace gets a unique dev URL).

To do so, you can either:

- Use SSH tunneling to tunnel the web app to individual developers' `localhost`
  instead of dev URLs (this is also an out-of-the-box feature included with VS
  Code Remote)
- Use this workaround for
  [multiple callback sub-URLs](https://stackoverflow.com/questions/35942009/github-oauth-multiple-authorization-callback-url/38194107#38194107)
