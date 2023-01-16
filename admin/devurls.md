# Dev URLs

Developer (dev) URLs allow users to access the ports of running applications
they develop within their workspace. Coder listens for the applications running
on the specified ports and provides a browser link that can be used to access
the application.

Before individual developers can set up dev URLs, an administrator must
configure and enable dev URL usage.

## Before you proceed

You must own a wildcard DNS record for your custom domain name to enable and use
dev URLs with Coder.

## Enabling the use of dev URLs

[Dev URLs](../workspaces/devurls.md) is an opt-in feature. To enable dev URLs in
your cluster, you'll need to modify your:

1. Helm chart
1. Wildcard DNS record

### Step 1: Modify the Helm chart

Set `coderd.devurlsHost` to a wildcard domain in your `values.yaml` file:

```yaml
coderd:
  devurlsHost: "*.my-custom-domain.io"
```

Run the `helm upgrade` command:

```console
helm upgrade coder coder/coder -n coder --version=<VERSION> --values values.yaml"
```

> Beginning with Coder version `1.26.0`, you can set a constant suffix for all
> dev URLs (e.g., `*-suffix.coder.io`). This feature helps organizations that
> may incur expenses and delays due to the need for multiple wildcard DNS
> records.

### Step 2: Modify the wildcard DNS record

The final step to enabling dev URLs is to update your wildcard DNS record. Get
the **LoadBalancer IP address** using `kubectl --namespace coder get svc` and
point your wildcard DNS record (e.g., \*.my-custom-domain.io) to the
**external-IP** value found in the `ingress-nginx` or the `coderd` lines.

## Step 3 (Optional): Add a TLS certificate

For secure (HTTPS) dev URLs, you can add (or generate) a TLS certificate for the
wildcard domain.

- See our
  [guide for creating a TLS certificate using LetsEncrypt](../guides/tls-certificates)
- To add a custom certificate, refer to our
  [Helm chart](https://github.com/cdr/enterprise-helm)

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

For example, if you set the maximum access level as **Authenticated**, then all
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
