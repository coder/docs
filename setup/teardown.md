---
title: Teardown
description: Learn how to teardown Coder and its associated infrastructure.
---

This guide shows you how to teardown Coder and the cluster it is deployed on.

**Note:** these instructions help you remove infrastructure spun up via our
[Kubernetes Documentation](https://coder.com/docs/setup/kubernetes), and do not
include teardown steps for any additional resources that may have been created
outside of these steps

## Amazon Elastic Kubernetes Service (EKS)

1. Make sure you're running `eksctl` version 0.37.0 or later by running
the following command:

```bash
eksctl version
```

2. List all services in the cluster by running the following command:

```bash
kubectl get svc --all-namespaces
```

3. Delete any services that have an `EXTERNAL-IP` value
by running the following command:

```bash
kubectl delete svc <service-name>
```

4. Delete the cluster and its underlying nodes by
running the following command:

```bash
eksctl delete cluster --name <prod>
```

## Azure Kubernetes Serivce (AKS)

1. Ensure the environment variable for `RESOURCE_GROUP` is set
to the one you want to delete in Azure by running the following command:

```bash
echo $RESOURCE_GROUP
```

2. Delete the cluster by running the following command:

```bash
az group delete --resource-group $RESOURCE_GROUP
```

## Google Kubernetes Engine (GKE)

1. Ensure the environment variables for `PROJECT_ID` and `CLUSTER_NAME` are still
set to the ones you want to delete in Google Cloud Platform (GCP).
Do this by running the following commands:

```bash
echo $PROJECT_ID
echo $CLUSTER_NAME
```

2. Delete the cluster by running the following command:

```bash
gcloud beta container --project $PROJECT_ID clusters delete \
$CLUSTER_NAME --zone <zone>

Thank you for using Coder! If you would like to provide feedback, you can do so here.
