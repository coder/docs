---
title: Workspace provider deployment
description: Learn how to deploy a workspace provider.
state: beta
---

This article walks you through the process of deploying a workspace provider to
a [Kubernetes cluster](../../setup/kubernetes/index.md).

## Dependencies

Install the following dependencies if you haven't already:

- [Coder CLI](../../cli/installation.md)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Requirements

1. Workspace providers **must have a hostname set** that is a subdomain of the
   Coder deployment. For example, if the Coder deployment's hostname is
   `coder.example.com`, the workspace provider's hostname must match the format
   `*.coder.example.com`.
1. The main Coder deployment and the workspace provider must be able to
   communicate bi-directionally via their respective hostnames.
1. The workspace provider scheme (HTTP or HTTPS) must match that of the Coder
   deployment Access URL.
1. The Kubernetes cluster address must be reachable from the Coder deployment.

## Connecting to the cluster

To add a Kubernetes cluster as a workspace provider, you must first make sure
that you're connected to the cluster you want to expand into. Run the following
command:

```bash
kubectl config current-context
```

Confirm that your current kubectl context correct before continuing; otherwise,
connect to the correct context.

## Creating the Coder namespace (optional)

We recommend running workspace providers in a separate
[namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/);
to do so, run:

```bash
kubectl create namespace [YOUR_WORKSPACE_PROVIDER_NAMESPACE]
```

Next, change the kubectl context to point to your newly created namespace:

```bash
kubectl config set-context --current --namespace=coder
```

## Creating the new workspace provider

1. Log in to Coder, and go to **Manage** > **Providers**.

1. Click **Create New** in the top-right corner to launch the **Create a
   Kubernetes Provider** page.

1. Provide a name for your new provider (e.g., `us-central-gpus`).

1. Under **Cluster Address**, provide the address of your Kubernetes control
   plane. If you don't know the address, you can get it by running the following
   in the terminal:

   ```console
   kubectl cluster-info
   ```

1. Provide the **namespace** to which Coder should provision new workspaces. If
   you don't already have one, you can create one by running the following in
   the terminal (replace `default` with the desired name -- this is also the
   value you'll provide to Coder):

   ```console
   kubectl create namespace default
   ```

1. Create a service account in the namespace that you specified in the previous
   step (Coder will use this account to provision workspaces):

   ```console
   kubectl apply -n default -f - <<EOF
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: coder
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: Role
   metadata:
     name: coder
   rules:
     - apiGroups: ["", "apps", "networking.k8s.io"] # "" indicates the core API group
       resources: ["persistentvolumeclaims", "pods", "deployments", "services", "secrets", "pods/exec","pods/log", "events", "networkpolicies"]
       verbs: ["create", "get", "list", "watch", "update", "patch", "delete", "deletecollection"]
     - apiGroups: ["metrics.k8s.io", "storage.k8s.io"]
       resources: ["pods", "storageclasses"]
       verbs: ["get", "list", "watch"]
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: RoleBinding
   metadata:
     name: coder
   subjects:
     - kind: ServiceAccount
       name: coder
   roleRef:
     kind: Role
     name: coder
     apiGroup: rbac.authorization.k8s.io
   EOF
   ```

   You should get a response similar to the following:

   ```console
   serviceaccount/coder created
   role.rbac.authorization.k8s.io/coder created
   rolebinding.rbac.authorization.k8s.io/coder created
   ```

1. Get the tokens required:

   ```console
   kubectl get secrets -n default -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='coder')].data}{'\n'}"
   ```

   Copy and paste the output returned from this command into the Coder.

1. Click **Create Provider** to proceed.
