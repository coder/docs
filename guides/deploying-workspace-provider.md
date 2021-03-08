---
title: Deploying Workspace Providers
description: Learn how to deploy a Workspace Provider with Helm and the coder CLI
---

This article walks you through the process of deploying a Workspace Provider
onto an additional [Kubernetes cluster](../setup/kubernetes/index.md).

[Workspace Providers](../admin/environment-management/workspace-providers.md)
are logical groups of resources you can deploy workspaces onto. Like the Coder
deployment, Workspace Providers are deployed via a helm chart into the kubernetes
cluster you'd like to provision new workspaces into.

## Dependencies

Install the following dependencies if you haven't already:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://helm.sh/docs/intro/install/)
- [Coder CLI](../cli/installation.md)

## Requirements

1. Workspace Providers **must have a hostname set** that is a subdomain of the
   Coder deployment. For example, if the Coder deployment's hostname is
   `coder.example.com`, the Workspace Provider must match the format
   `*.coder.example.com`.
2. The main Coder deployment and the Workspace Provider must be able to
   successfully communicate bidirectionally via their respective hostnames.
3. The kubernetes cluster address must be reachable from the Coder deployment.

## Connecting to the cluster

To add a kubernetes cluster as a Workspace Provider, we first must ensure we
are connected to the cluster we wish to expand into.

```bash
kubectl config current-context
```

Confirm your current kubectl context is the correct cluster before continuing.

## Creating the Coder Namespace (Optional)

We recommend running Workspace Providers in a separate
[namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/);
to do so, run

```bash
kubectl create namespace coder
```

Next, change the kubectl context to point to your newly created namespace:

```bash
kubectl config set-context --current --namespace=coder
```

## Creating the New Workspace Provider

Using the Coder CLI, we will create a new Workspace Provider in a `pending`
state.

You must provide the following arguments:

- `name`: A unique name of the Workspace Provider
- `hostname`: Hostname of the Workspace Provider
- `clusterAddress`: The address of the kubernetes cluster apiserver. This can
  be retrieved with the command
  `kubectl config view -o jsonpath='{.clusters[?(@.name == "'"$(kubectl config current-context)"'")].cluster.server}{"\n"}'`

```bash
coder providers create \
    --name=[NAME] \
    --hostname=[HOSTNAME] \
    --clusterAddress=[CLUSTER_ADDRESS]
```

The command will generate a helm command you can use for the next steps, so make
sure to save the output for the next steps.

The returned `REMOTE_ENVPROXY_TOKEN` is a shared secret between the two
deployments, and is what the Workspace Provider will use to authenticate itself
when communicating with the Coder deployment.

## Installing Workspace Provider

1. If you haven't already, add the Coder helm repo

   ```bash
   helm repo add coder https://helm.coder.com
   ```

2. Install the helm chart onto your cluster using the generated helm command
   from before. The helm command will follow the pattern:

```bash
helm upgrade coder-workspace-provider coder/workspace-provider \
    --version=[CODER_VERSION] \
    --atomic \
    --install \
    --force \
    --set envproxy.token=[REMOTE_ENVPROXY_TOKEN] \
    --set ingress.host=[HOSTNAME] \
    --set envproxy.clusterAddress=[CLUSTER_ADDRESS] \
    --set cemanager.AccessURL=[CEMANAGER_ACCESS_URL]
```

You can optionally provide additional helm values by providing a `values.yaml`
file and adding the argument `-f my-values.yaml` to the generated command. Helm
values control attributes of the Workspace Provider such as controlling DevURLs,
kubernetes storage classes, enabling SSH, and more. See the
[Workspace Provider Helm Chart Values]("https://github.com/cdr/enterprise-helm/blob/workspace-providers-envproxy-only/README.md")
for more details.

3. Once the Helm chart has deployed successfully, you should see the workspace provider
  in a `ready` state on the Workspace Provider Admin page.

![Workspace Providers Admin](../assets/workspace-providers-admin.png)

4. From the Workspace Provider Admin page, add the desired organizations to the
   allowlist. Users in the allowed organizations can now choose to deploy into
   the newly setup Workspace Provider.

## Upgrading the Workspace Provider

Upgrades to all Workspace Providers should be done in lockstep with the Coder
deployment. Only the `--version` flag needs to be updated if no other helm
values changes are desired, and can be done with the following command:

```bash
helm upgrade coder-workspace-provider coder/workspace-provider \
    --version=[CODER_VERSION] \
    --atomic \
    --install \
    --force
```

If you desire to update any of the helm chart's values you can do so by
supplying a values file (`-f myvalues.yaml`) or explicitly with the `--set`
flag. Any existing values that were set during installation will persist unless
they are explicitly overwritten.

## Deleting a Workspace Provider

A Workspace Provider can only be removed if it no longer contains any
workspaces, so you must remove any remaining workspaces before attempting to
delete the Workspace Provider.

To remove a Workspace Provider run the following command via the Coder CLI:

```bash
coder providers rm [NAME]
```
