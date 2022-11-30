---
title: "PostgreSQL"
description: "Learn how connect Coder to an external postgreSQL database."
---

This guide walks you through deploying Coder with an external PostgreSQL
database.

## Background

For convenience and ease of installation, Coder's default Helm Chart settings
will deploy a [PostgreSQL database](https://www.postgresql.org/) within the
installation's Kubernetes namespace. This is useful for evaluation purposes;
however, we **recommend using an out-of-cluster database for production** to
streamline maintenance operations, such as backups and upgrades. The database
state is _not_ backed up and will be lost when deleting the Kubernetes namespace
or cluster.

## Configuration steps

> For optimal performance, it is important to ensure that the round-trip latency
> between the Coder control plane services and the database is low. We recommend
> ensuring that the database is within the same data center as the control
> plane, such as within the same cloud availability zone.

1. Set up a PostgreSQL database for use with Coder. If you do not already have
   an instance available, consider using the service from your cloud provider:

   - [Amazon Relational Database Service (RDS)](https://aws.amazon.com/rds/)
   - [Azure Database for PostgreSQL](https://azure.microsoft.com/en-us/services/postgresql/)
   - [Google Cloud SQL](https://cloud.google.com/sql)

1. Configure a private IP address for use with your PostgreSQL instance. You
   will set this in the [Helm settings (values file)](../admin/helm-charts.md)).

1. If your PostgreSQL instance requires a password, you will need to create a
   Kubernetes Secret containing the password:

   ```console
   kubectl create secret generic <NAME> --from-file=password=/dev/stdin
   ```

   We recommend using the syntax provided above, which reads credentials from
   the console, to avoid inadvertently storing credentials in shell history
   files.

   > Normally, we set the PostgreSQL password as an environment variable in the
   > `coderd` deployment with a reference to the Kubernetes secret. If this is
   > not desirable, you can instead mount the secret as a file which Coder will
   > read at startup. To do this, set the Helm value `postgres.noPasswordEnv` to
   > `true`. This will mount the secret under
   > `/run/secrets/<.Values.postgres.passwordSecret>/password` and set the
   > environment variable `DB_PASSWORD_PATH` for `coderd` to that value.

1. Get the port number for your PostgreSQL instance:

   ```sql
   SELECT *
   FROM pg_settings
   WHERE name = 'port';
   ```

1. Get the user of the PostgreSQL instance:

   ```plaintext
   \du
   ```

1. Get the name of the database _within_ your PostgreSQL instance in which
   you're currently working:

   ```sql
   SELECT current_database();
   ```

1. Get the name of the secret you created for your PostgreSQL instance's
   password:

   ```console
   kubectl get secrets --namespace=<your-coder-namespace>
   ```

Set the database name, port number, user, and password secret created in the
prior steps [in your Helm values file](../admin/helm-charts.md). Coder will use
these credentials to connect to your PostgreSQL instance:

```yaml
postgres:
  host: "<your-postgres-private-ip>"
  port: "<your-postgres-port>"
  user: "<your-postgres-user>"
  database: "<your-db-name>"
  passwordSecret: "<your-postgres-secret-name>"
```

> Ensure that there are no trailing white spaces in your password secret.

### mTLS connections

Coder supports mutual TLS (mTLS) connections to Postgres databases; if you'd
like to enable this feature,
[provide the necessary values in `postgres.ssl`](https://github.com/coder/enterprise-helm/blob/24a7a3efd3ccb8b8103e0ecaa888ba0de05de12e/values.yaml#L297).

### Using AWS IAM to authenticate with an RDS instance

You can set the Postgres connector option in the Helm chart. If you'd like to
use the environment's AWS IAM account to authenticate with an RDS instance,
[set `postgres.connector` accordingly](https://github.com/coder/enterprise-helm/blob/24a7a3efd3ccb8b8103e0ecaa888ba0de05de12e/values.yaml#L316).

### Upgrade Coder

At this point, you can install/upgrade your Coder instance using the updated
Helm chart.

To install Coder for the first time:

```console
helm install coder coder/coder --namespace=<your-coder-namespace> \
  --version=<VERSION> --values=current-values.yml --wait
```

To upgrade Coder:

```console
helm upgrade coder coder/coder --namespace=<your-coder-namespace> \
  --version=<VERSION> --values=current-values.yml --wait
```

If the upgrade fails for any reason, please run the `helm rollback` command and
[contact our support team](../../feedback.md) for assistance.

Once you complete this process, you'll be able to access Coder using the
external IP address of the ingress controller in your cluster.

### Scaling Coder & PostgreSQL

Each Coder replica maintains a pool of connections to Postgres, capped at a
maximum of 30 connections by default. This value strikes a balance between
allowing multiple concurrent requests and using up connections on the Postgres
database.

To reconfigure this value, set the environment variable
`CODER_MAX_DB_CONNECTIONS` to your desired value in the `coderd.extraEnvs`
section of the Helm chart.

> **Important**: You must ensure that Coder's maximum connections per replica
> times the number of Coder replicas is less than the maximum number of
> connections your Postgres instance allows, assuming Coder is the only
> application using the Postgres instance (less if other applications will also
> consume connections). For example, with 3 Coder replicas and the default max
> connections of 30, you must ensure Postgres is configured to allow 90
> connections. If Postgres runs out of connections Coder may fail API requests
> or builds.

By default, Postgres allows a maximum of 100 open connections (less 3 reserved
for superusers). Consult
[Postgres documentation](https://www.postgresql.org/docs/12/runtime-config-connection.html),
or your database administrator for information on how to change this value.

Consider monitoring the [`go_sql_open_connections`](../admin/prometheus.md)
metric to see how many connections Coder uses in different load scenarios.
