After installation, you'll set up and configure Coder using its web UI.

## Before You Start

Make sure you have the following information on hand:

- The **admin user credentials** that were presented to you at the end of the
  [installation](installation.md) process

- Your **Coder license**; you must provide your license key during setup and
  config. Your license should have been sent to you via email; if not, please
  reach out to your Coder sales representative.

### Creating Your License File

Coder provides you with your licensing information, which looks like:

```text
{"owner":"yourName","issued_at":"2020-01-01T00:00:00Z","expires_at":"2020-01-02T00:00:00Z","max_usage":{"user_count":10},"paid":false,"nonce":"MjA...MDA=","version":1,"checksum":"VtG...uQ=="}
```

Copy this information into the text editor of your choice, and save it as a .txt
or a .json file. You will be asked to upload this file at two points during the
setup and configuration processes.

## Set Up Your Coder Deployment

1. Get the IP address you need to access the Web UI. To do so, run the following
   in the terminal to list the Kubernetes services running:

   ```bash
   kubectl --namespace coder get services
   ```

   The row for the **ingress-nginx** service includes an **EXTERNAL-IP** value;
   this is the IP address you need.

2. In your browser, navigate to the external IP of ingress-nginx.

3. Use your admin credentials to log in to the Coder platform. If this is the
   first time that you've logged in, you'll be prompted to create a new password
   for the site admin user.

4. Upload your license (you must provide a JSON file).

## Configure Your Coder Deployment

Once you log in to Coder's Web UI, you'll be walked through a configuration
dashboard. You can specify the authentication method used for logins, provide
your license information, and more.

After you complete this process, you'll be redirected to the main Coder
deployment dashboard, where you can create new users, images, and environments.

> After completing the configuration process, we recommend creating a **site
> manager** user that can be used to create additional users and resources. **We
> recommend using the site admin user only for initial configuration purposes.**

### Best Practices

Coder's default values during the setup/configuration process are acceptable
only by a deployment used for evaluation purposes.
