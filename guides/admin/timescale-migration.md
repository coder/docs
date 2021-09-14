---
title: Migrating data from TimescaleDB
description: Learn how to migrate data from the TimescaleDB to a PostgreSQL
instance.
---

## Background

By default, Coder will deploy a Timescale database within the installation's
Kubernetes namespace. We recommend using this database _only_ for evaluation
purposes. With this in mind, you might want to migrate the data stored in your
Timescale instance over to an out-of-cluster PostgreSQL database

**Note**: The following steps require Kubernetes cluster-admin access.

## Migration Steps

1. Access the timescale pod and dump the database into a file:

```console
kubectl exec -it statefulset/timescale -n coder -- pg_dump -U coder -d coder > backup.sql
```

> If your database is large, you can truncate Coder's telemetry, metrics, and
> audit log to reduce the file size.

1. Access your PostgreSQL instance and create user `coder`

1. Import the data into your database:

``` console
cat backup.sql > psql -U coder
```

1. Connect your Coder instance to the database:

```console
helm upgrade -n coder coder coder/coder \
    --set postgres.default.enable=false \
    --set postgres.host=<HOST_ADDRESS> \
    --set postgres.port=<PORT_NUMBER> \
    --set postgres.user=<DATABASE_USER> \
    --set postgres.database=<DATABASE_NAME> \
    --set postgres.passwordSecret=<secret-name> \
    --set postgres.sslMode=require
```

1. (Optional) If you'd like to delete the Timescale persistent volume, run:

```console
kubectl delete pvc timescale-data-timescale-0 -n coder
```

At this point, you should be able to successfully login to your Coder deployment.
