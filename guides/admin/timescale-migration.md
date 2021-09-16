---
title: Database migration
description: Learn how to migrate data from Coder's built-in PostgreSQL database
to an external PostgreSQL instance.
---

By default, Coder deploys a built-in database in the installation's Kubernetes
namespace. We recommend using this database _only_ for evaluation purposes.

At the end of your evaluation period, you may need to migrate the data from the
built-in database to an out-of-cluster PostgreSQL database for production use.
This article will walk you through the process of doing so.

> You must be a cluster admin for your Kubernetes cluster.

## Migration Steps

1. Access the database pod and dump the database into a file:

   ```console
   kubectl exec -it statefulset/timescale -n coder -- pg_dump -U coder -d coder > backup.sql
   ```

1. **Optional**: If your database is large, you can truncate Coder's telemetry,
   metrics, and audit log data to reduce the file size:

   ```psql
   TRUNCATE metric_events;
   TRUNCATE environment_stats;
   TRUNCATE audit_logs;
   ```

1. Access your PostgreSQL instance and create user `coder` and database `coder`

1. Import the data you exported in the first step into your external database:

   ```psql
   psql -U coder < backup.sql
   ```

1. Connect your Coder instance to the database:

   ```console
   helm upgrade --reuse-values -n coder coder coder/coder \
       --set postgres.default.enable=false \
       --set postgres.host=<HOST_ADDRESS> \
       --set postgres.port=<PORT_NUMBER> \
       --set postgres.user=<DATABASE_USER> \
       --set postgres.database=<DATABASE_NAME> \
       --set postgres.passwordSecret=<secret-name> \
       --set postgres.sslMode=require
   ```

1. **Optional**: If you'd like to delete the Timescale persistent volume, run:

   ```console
   kubectl delete pvc timescale-data-timescale-0 -n coder
   ```

At this point, you should be able to log in to your Coder deployment
successfully.
