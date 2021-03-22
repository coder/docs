---
title: Teardown
description: Learn how to tear down Coder and the infrastructure on which it's deployed.
---

This guide shows you how to tear down Coder and the cluster it is deployed on.

> These instructions help you remove infrastructure created when following our
[Kubernetes setup tutorials](../../setup/kubernetes/index.md). They do not
include teardown steps for any additional resources that you create.  If you
need to keep your cluster, you can run `helm uninstall coder`, which deletes all
Coder services but retains environments and their associated disk space.

## Amazon Elastic Kubernetes Service (EKS)

1. Make sure you're running `eksctl` version 0.37.0 or later:

    ```bash
    eksctl version
    ```

1. List all of the services in your cluster:

    ```bash
    kubectl get svc --all-namespaces
    ```

1. Delete any services that have an `EXTERNAL-IP` value in your namespace:

    ```bash
    kubectl delete svc <service-name>
    ```

1. Delete the cluster and its underlying nodes:

    ```bash
    eksctl delete cluster --name <prod>
    ```

## Azure Kubernetes Service (AKS)

1. Make sure that the environment variable for `RESOURCE_GROUP` is set to the
   one you want to delete in Azure:

    ```bash
    echo $RESOURCE_GROUP
    ```

    If the variable is incorrect, fix it by setting it to the proper value:

    ```bash
    RESOURCE_GROUP="<MY_RESOURCE_GROUP_NAME>"
    ```

1. Delete the cluster:

    ```bash
    az group delete --resource-group $RESOURCE_GROUP
    ```

## Google Kubernetes Engine (GKE)

1. Ensure that the environment variables for `PROJECT_ID` and `CLUSTER_NAME` are
   set to those for the cluster you want to delete:

    ```bash
    echo $PROJECT_ID
    echo $CLUSTER_NAME
    ```

    If these values are incorrect, you can fix this by providing the proper
    names:

    ```bash
    PROJECT_ID="<MY_RESOURCE_GROUP_NAME>" \
    CLUSTER_NAME="<MY_CLUSTER_NAME>"
    ```

1. Delete the cluster:

    ```bash
    gcloud beta container --project $PROJECT_ID clusters delete \
    $CLUSTER_NAME --zone <zone>
    ```
