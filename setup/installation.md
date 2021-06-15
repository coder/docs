---
title: "Installation"
description: Learn how to install Coder onto your infrastructure.
---

This article walks you through the process of installing Coder onto your
[Kubernetes cluster](kubernetes/index.md).

## Dependencies

Install the following dependencies if you haven't already:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)

**For production deployments:** set up and use an external
[PostgreSQL](https://www.postgresql.org/docs/12/admin.html) instance to store
data, including workspace information and session tokens.

## Creating the Coder namespace (optional)

We recommend running Coder in a separate
[namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/);
to do so, run

```console
kubectl create namespace coder
```

Next, change the kubectl context to point to your newly created namespace:

```console
kubectl config set-context --current --namespace=coder
```

## Installing Coder

1. Add the Coder Helm repo

   ```console
   helm repo add coder https://helm.coder.com
   ```

1. Install the Helm chart onto your cluster (see the
   [changelog](../changelog/index.md) for a list of Coder versions or run
   `helm search repo coder -l`)

   ```console
   helm install coder coder/coder --namespace coder --version=<VERSION>
   ```

   **Steps 3-5 are optional for non-production deployments.**

1. Get a copy of your Helm config values so that you can modify it; you'll need
   to modify these values to update your PostgreSQL databases (step 4) and
   enable dev URLs (step 5):

   a. Create an empty file called `values.yaml` which will contain your
   deployment configuration options.

   b. Edit the `values.yaml` file as needed.

   > View the
   > [configuration options available in the `values.yaml` file.](https://github.com/cdr/enterprise-helm#values)

   c. Upgrade/install your Coder deployment with the updated Helm chart (be sure
   to replace the placeholder value with your Coder version). **This must be
   done whenever you update the Helm chart:**

   ```console
   helm upgrade coder coder/coder --namespace coder --version=<VERSION> --values values.yaml
   ```

   > If you omit `--version`, you'll upgrade to the latest version, excluding
   > release candidates (RCs). To include RCs, provide the `--devel` flag.
   >
   > We do not provide documentation for RCs, and you should not use them unless
   > you've been instructed to do so by Coder. You can identify RCs by the
   > presence of `-rc` in the version number (e.g., `1.16.0-rc.1`).

1. Ensure that you have superuser privileges to your PostgreSQL database. Add
   the following to your Helm values so that Coder uses your external PostgreSQL
   databases:

   ```yaml
   postgres:
     useDefault: false
     host: HOST_ADDRESS
     port: PORT_NUMBER
     user: YOUR_USER_NAME
     database: YOUR_DATABASE
     passwordSecret: secret-name
     sslMode: require
   ```

   To create the `passwordSecret`, run:

   ```console
   kubectl create secret generic <NAME> --from-file=password=/dev/stdin
   ```

   This allows you to enter the password in the command line without logging it.
   Do **not** press enter/return to avoid adding a newline character to the
   password (pressing **Cmd/Ctrl-D** twice will end data entry and save the
   secret).

   You can find/define these values in your
   [PostgreSQL server configuration file](https://www.postgresql.org/docs/current/config-setting.html).

   > For more information, [see our guide](../guides/deployments/postgres.md) on
   > setting up a PostgreSQL instance.

1. [Enable dev URL usage](../admin/devurls.md). Dev URLs allow users to access
   the web servers running in your workspace. To enable, provide a wildcard
   domain and its DNS certificate and update your Helm chart accordingly. This
   step is **optional** but recommended.

1. After you've created the pod, tail the logs to find the randomly generated
   password for the admin user

   ```console
   kubectl logs -n coder -l coder.deployment=cemanager -c cemanager \
    --tail=-1 | grep -A1 -B2 Password
   ```

   When this step is done, you will see:

   ```text
   ----------------------
   User:     admin
   Password: kv...k3
   ----------------------
   ```

   These are the credentials you need to continue setup using Coder's web UI.

> If you lose your admin credentials, you can use the
> [admin password reset](../admin/access-control/password-reset.md#resetting-the-site-admin-password)
> process to regain access.

## Logging

At this time, we recommend review Coder's default
[logging](../guides/admin/logging.md) settings. Logs are helpful for monitoring
the health of your cluster and troubleshooting, and Coder offers you several
options for obtaining these.

## Accessing Coder

1. To access Coder's web UI, you'll need to get its IP address by running the
   following in the terminal to list the Kubernetes services running:

   ```console
   kubectl --namespace coder get services
   ```

   The row for the **ingress-nginx** service includes an **EXTERNAL-IP** value;
   this is the IP address you need.

1. In your browser, navigate to the external IP of ingress-nginx.

1. Use the admin credentials you obtained in this installation guide's previous
   step to log in to the Coder platform. If this is the first time you've logged
   in, Coder will prompt you to change your password.

At this point, you're ready to proceed to [configuring Coder](configuration.md).