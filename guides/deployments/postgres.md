---
title: "PostgreSQL"
description: "Learn how connect Coder to an external postgreSQL database."
---

This guide walks you through deploying Coder with an external PostgreSQL
database.

## Background

For convenience and ease of installation, Coder's default Helm Chart settings
will  [PostgreSQL database](https://www.postgresql.org/) within the
installation's Kubernetes namespace. This is useful for evaluation purposes;
however, we **recommend using an out-of-cluster database for production**, to
streamline maintenance operations, such as backups and upgrades. The database
container is not backed up and will be lost when deleting the namespace or
Kubernetes cluster.

> For optimal performance, it is important to ensure that the round-trip latency
> between the Coder control plane services and the database is low. We recommend
> ensuring that the database is within the same datacenter as the control plane,
> such as within the same cloud availability zone.

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
helm install coder coder/coder --namespace=<your-coder-namespace> --version=<VERSION> --values=current-values.yml
```

To upgrade Coder:

```console
helm upgrade coder coder/coder --namespace=<your-coder-namespace> --version=<VERSION> --values=current-values.yml
```

Once you complete this process, you'll be able to access Coder using the
external IP address of the ingress controller in your cluster.
