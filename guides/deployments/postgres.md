---
title: "PostgreSQL"
description: "Learn how connect Coder to an external postgreSQL database."
---

This guide walks you through deploying Coder with an external PostgreSQL
database.

## Background

By default, Coder deploys a [TimescaleDB](https://www.timescale.com) inside the
Kubernetes cluster to which you've installed Coder. However, we recommend this
**only for evaluation purposes**, since the database isn't backed up and can be
lost if the cluster goes down.

As such, we strongly recommend using a PostgreSQL database for production
deployments and hosting it **outside** the Kubernetes cluster hosting Coder.

1. Set up a PostgreSQL instance (if you don't already have one that you can use
   with Coder). How you can do this depends on your cloud provider, but the
   following resources are good starting points:

   - [Amazon Relational Database Service (RDS) backup & restore using AWS
     Backup](https://aws.amazon.com/getting-started/hands-on/amazon-rds-backup-restore-using-aws-backup)
   - [Quickstart: Create an Azure Database for PostgreSQL server by using the
     Azure
     portal](https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-server-database-portal)
   - [Deploying highly available PostgreSQL with
     GKE](https://cloud.google.com/architecture/deploying-highly-available-postgresql-with-gke)

1. Configure a private IP address for use with your PostgreSQL instance (you'll
   need to refer to this IP address in your [Helm
   chart](../admin/helm-charts.md)).

1. If your PostgreSQL instance requires a password, open the terminal, connect
   to your cluster, and create a secret for the password:

   ```console
   kubectl create secret generic <NAME> --from-file=test=/dev/stdin
   ```

1. Get the port number for your PostgreSQL instance:

   ```sql
   SELECT *
   FROM pg_settings
   WHERE name = 'port';
   ```

1. Get the user of the PostgreSQL instance:

   ```sql
   \du
   ```

1. Get the name of the database *within* your PostgreSQL instance in which
   you're currently working:

   ```sql
   SELECT current_database();
   ```

1. Get the name of the secret you created for your PostgreSQL instance's
   password:

   ```console
   kubectl get secrets -n <your-coder-namespace>
   ```

At this point, you can [modify your Helm chart](../admin/helm-charts.md) to
include the database name, port number, user, and password secret that you
identified in the previous steps (these values are required to connect to your
PostgreSQL instance):

```yaml
postgres:
  useDefault: false
  host: "<your-postgres-private-ip>"
  port: "<your-postgres-port>"
  user: "<your-postgres-user>"
  database: "<your-db-name>"
  passwordSecret: "<your-postgres-secret-name>"
```

At this point, you can install/upgrade your Coder instance using the updated
Helm chart.

To install Coder:

```console
helm install coder coder/coder -n <your-coder-namespace> --version=<VERSION> -f current-values.yml
```

To upgrade Coder:

```console
helm upgrade coder coder/coder -n <your-coder-namespace> --version=<VERSION> -f current-values.yml
```

If this process is successful, you'll be able to access Coder using the external
IP address of the ingress controller in your cluster.
