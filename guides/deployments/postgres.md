---
title: "Connect an External PostgreSQL"
description: "Learn how connect Coder to an external postgreSQL database."
---

This guide walks through the steps to deploying Coder with an external
PostgreSQL database connected.

## Connecting to an external PostgreSQL

By default, Coder will deploy a [TimescaleDB](https://www.timescale.com) inside
the Kubernetes cluster used to install Coder. However, this is _only_
recommended for evaluation purposes, as the database is not backed up, and can
be lost if the cluster goes down.

For those reasons, we recommend bringing in your own PostgreSQL for production
deployments, and hosting it external to the cluster. Below are the steps to do
so:

1. Spin up a PostgreSQL instance if you have not already done so

1. Configure a private IP address for the PostgreSQL instance

- This private IP will be referenced in the Coder helm chart configuration

1. If your PostgreSQL instance has a password, follow the below:

- Open the terminal, connect to your cluster and create a secret:

  ```console
  kubectl create secret generic <YOUR-DB-SECRET> \
      --from-literal=password=<YOUR-DATABASE-PASSWORD> \
  ```

1. Get the port number for your PostgreSQL instance

- When you install PostgreSQL, the default port number is set to `5432`.
  Otherwise, you can get the port number by running the following in your
  database:

```sql
SELECT *
FROM pg_settings
WHERE name = 'port';
```

1. Get the user of the PostgreSQL instance

- You can find the user by running the following command in your database:

```sql
\du
```

1. Get the name of the database _within_ your PostgreSQL instance

- You can get the name of the current database you are working in by running the
  following command in your database:

```sql
SELECT current_database();
```

1. Get the name of the secret you created for the database password

- You can get the secret name by running the following command:

```console
kubectl get secrets -n <your-coder-namespace>
```

From there, we can now modify the helm chart to include the PostgreSQL values we
received above, which are necessary for completing the connection. To get your
current helm chart and save it to a file, run the following command in your
terminal:

```console
helm helm get values --namespace <your-coder-namespace> coder > current-values.yml
```

Next, modify the helm chart fields with the values below:

```yaml
postgres:
  useDefault: false
  host: "<your-postgres-private-ip>"
  port: "<your-postgres-port>"
  user: "<your-postgres-user>"
  database: "<your-db-name>"
  passwordSecret: "<your-postgres-secret-name>"
```

Once complete, you can now install (or upgrade) your Coder instance with the
modified helm chart using the following commands:

- For install:

```console
helm install coder coder/coder -n <your-coder-namespace> --version=<VERSION> -f current-values.yml
```

- For upgrading:

```console
helm upgrade coder coder/coder -n <your-coder-namespace> --version=<VERSION> -f current-values.yml
```

If successful, you should be able to access your Coder application from the
`EXTERNAL_IP` of the ingress controller in your cluster.
