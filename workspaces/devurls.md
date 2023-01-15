# Dev URLs

Developer (dev) URLs allow you to access the web services you're developing in
your workspace. Once defined, Coder listens for an application running on the
port specified in the dev URL and renders a browser link you can use to view the
application.

> You must have [dev URLs enabled](../admin/devurls.md) in your installation.

## Creating a dev URL

You can create a dev URL from the workspace overview page.

In the **Dev URLs** section, click **Add Port**. First, provide the **port**
number for your application and a friendly **name** for the dev URL (optional).

Next, indicate who should be able to **access** the dev URL and the **internal
server scheme** (e.g., whether Coder should use HTTP or HTTPS when proxying
requests to the internal server).

![Create a dev URL](../assets/workspaces/create-devurl.png)

## Access control

You can set the access level for each dev URL:

- **Private** - Only the owner of the workspace can access the dev URL
- **Organization** - Anyone in the same Coder organization as the workspace can
  access the dev URL
- **Authorized Users** - Anyone logged in to your Coder instance can access the
  dev URL
- **Public** - Anyone outside the Coder deployment's network can access the dev
  URL (organization-defined firewall rules and VPNs can still restrict access)

## Using dev URLs

To access and manage a dev URL, you can click:

- The **Open in browser** icon to the left of the dev URL name to launch a new
  browser window
- The **Copy URL** action to copy the dev URL for sharing
- The **Edit URL** action to edit the dev URL
- The **Delete URL** action to delete the dev URL

> Coder's dev URL upload limit is **1 MB**.

![Dev URLs List](../assets/workspaces/create-devurl.png)

### Direct access

There are two ways for you to construct dev URLs.

If you provided a name for the dev URL when you created it:

```text
devUrlName--username.domain

# ex: main--jessieLorem.exampleCo.com
```

If you didn't provide a name for the dev URL when you created it:

```text
portNumber--workspaceName-username.domain

# ex: 8080--mainDev-jessieLorem.exampleCo.com
```

For example, let's say that you've created a dev URL for port `8080`. Also:

- Username: `user`
- Domain: `acme.com`
- Workspace: `my-project`

If you didn't name your dev URL, then your URL is
`8080--my-project-user.acme.com`.

If, however, you named the dev URL `reactproject`, then your URL is
`reactproject--user.acme.com`.

If you access a dev URL that hasn't been created, Coder automatically adds it to
your dev URL list on the dashboard and sets the access level to **Private**.

## Programmatically accessing dev URLs

If you need programmatic access to authenticated dev URLs (i.e., dev URLs with
access levels set to **private**, **organization**, or **authorized users**),
you can run the following in the terminal:

```console
# Generate an API token with the Coder CLI
$ coder tokens create devurl
<TOKEN>

# Send HTTP requests to the dev URL using the devurl_session cookie
$ curl --cookie "devurl_session=<TOKEN>" <dev-url>
```

## Access via SSH port forwarding

You can also access your server via
[SSH port forwarding](ssh.md#forwarding-dev-urls).

## Troubleshooting

If you're seeing issues with your dev URL, we recommend using something like
Python's `http.server` module to gain additional information helpful for
troubleshooting issues with DevURL configuration and external proxies:

```console
# update the following with the port you're troubleshooting
python3 -m http.server 8080
```
