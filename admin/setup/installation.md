This article walks you through the process of installing Coder.

## Dependencies

Install the following dependencies:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://helm.sh/docs/intro/install/)

**For Production deployments:** set up and use an external
[PostgreSQL](https://www.postgresql.org/docs/12/admin.html) instance to store
data, including environment information and session tokens.

## Installing Coder

1. Add the Coder helm repo

   ```bash
   helm repo add coder https://helm.coder.com
   ```

2. Install the helm chart into the cluster

   ```bash
   helm install --namespace coder coder coder/coder --version <VERSION-NUMBER>
   ```

3. **For Production deployments:** Add the following to your helm chart so that
   Coder uses your external PostgreSQL databases:

   ```yaml
   postgres:
     useDefault: false
     host: HOST_ADDRESS
     port: PORT_NUMBER
     user: YOUR_USER_NAME
     database: YOUR_DATABASE
     passwordSecret: postgres-master
     sslMode: require
   ```

   You can find/define these values in your [PostgreSQL server configuration
   file](https://www.postgresql.org/docs/current/config-setting.html).

4. [Enable Dev URL Usage](../devurls.md). Dev URLs allow users to access
   the web servers running in your environment. To enable, provide a wildcard
   domain and its DNS certificate and update your helm chart accordingly.

5. After you've created the pod, tail the logs to find the randomly generated
   password for the admin user

   ```bash
   kubectl logs -l coder.deployment=cemanager -c cemanager \
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

> If you lose your admin credentials, you can use the [admin password
> reset](https://help.coder.com/hc/en-us/articles/360057772573) process to
> regain access.
