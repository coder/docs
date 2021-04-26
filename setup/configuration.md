---
title: "Configuration"
description: Learn how to configure a fresh Coder installation.
---

After installation, you'll set up and configure Coder using its web UI.

## Before you start

You should have completed the [installation](installation.md) process and
successfully logged in to Coder.

Make sure you have the following information on hand:

- The **admin user credentials** for your Coder deployment (necessary if you're
  not already logged in).

- Your **Coder license**; you must provide your license key during setup and
  config. Your license should have been sent to you via email; if not, please
  reach out to your Coder sales representative.

> If you do not have a license, you can [generate one](https://coder.com/trial)
> that allows you to try Coder free of charge for 60 days.

### Creating your license file

Coder provides you with your licensing information, which looks like:

```text
{"owner":"yourName","issued_at":"2020-01-01T00:00:00Z","expires_at":"2020-01-02T00:00:00Z","max_usage":{"user_count":10},"paid":false,"nonce":"MjA...MDA=","version":1,"checksum":"VtG...uQ=="}
```

Copy this information into the text editor of your choice, and save it as a .txt
or a JSON file. You'll need to upload this file at two points during the setup
and configuration processes.

## Providing your license

Immediately after logging into Coder for the first time, you'll be prompted to
upload your license (you must provide a JSON file).

Once done, you can proceed with the Coder configuration process.

## Configure your Coder deployment

Once you log in to Coder's Web UI, you'll be walked through a configuration
dashboard. You can specify the authentication method used for logins, provide
your license information, and more.

After you complete this process, you'll be redirected to the main Coder
dashboard, where you can create new users, images, and workspaces.

> After completing the configuration process, we recommend creating a **site
> manager** user that can be used to create additional users and resources. **We
> recommend using the site admin user only for initial configuration purposes.**

### Best practices

Coder's default values during the setup/configuration process are acceptable
only by a deployment used for evaluation purposes.
