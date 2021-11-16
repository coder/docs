---
title: Kubernetes
description: Learn how to deploy a workspace provider to a Kubernetes cluster.
---

This article walks you through the process of deploying a workspace provider to
a Kubernetes cluster. If you do not have one, you can use our
[cluster guides](../../../setup/kubernetes/index.md) to create one compatible
with Coder.

## Dependencies

Install the following dependencies if you haven't already:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

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
   the terminal:

   ```console
   kubectl create namespace <NAMESPACE>
   ```

1. Create a `ServiceAccount`, `Role`, and `Rolebinding` in the namespace that
   you specified in the previous step (Coder will use this account to provision
   workspaces):

   ```console
   kubectl apply -n <NAMESPACE> -f - <<EOF
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

1. Retrieve the service account token and certificate, which Coder uses to
   authenticate with the Kubernetes cluster.

   ```console
   kubectl get secrets -n <NAMESPACE> -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='coder')].data}{'\n'}"
   ```

   Copy and paste the output returned from this command into the Coder form.

1. Click **Create Provider** to proceed. Coder will deploy your provider at this
   point.

## Allowlist organizations

Before users can provision workspaces using the provider, you must edit the
provider and indicate the organizations that can use the provider.

Once Coder has deployed your provider, you'll see it listed on the **Providers**
page. Click the vertical ellipsis to its right, and select **Edit**. Scroll down
to **Organizations** and select the ones you want to be able to use this
provider.

Users in the allowed organizations can now choose to deploy into the newly set
up workspace provider.

## Using workspace providers in separate regions

Workspace providers enable a single Coder deployment to manage resources
anywhere you can deploy Kubernetes. A common use case this feature enables is to
colocate the developer's physical location and workspace location to the same
geographic region.

To ensure low latency in these scenarios, you should deploy
[satellites](../satellites/index.md) into these regions. Satellites enable
traffic to stay within the region and provide an improved user experience.
