# Manage satellites

This article will show you how to deploy a satellite to reduce latency. It also
covers how to view a list of your satellites and how to remove satellites.

## Creating a Satellite

To create a new satellite, you must update the Coder Helm chart to enable
`satellite` mode, deploy Coder, and register the new deployment using the Coder
CLI.

## Dependencies

Install the following dependencies if you haven't already:

- [Coder CLI](../../cli/installation.md)
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Requirements

1. You must be a Coder site manager and have
   [authenticated with the Coder CLI](../../cli/installation.md#authenticate).

1. The satellite deployment must be able to communicate with the primary Coder
   deployment via HTTPS.

## Step 1: Confirming your context

First, make sure that you're connected to the cluster to which you want to
deploy the satellite. Ideally, this deployment should be in the same
geographical region as the developers' and their workspaces.

To see your current context, run:

```console
kubectl config current-context
```

Confirm that your current kubectl context is correct before continuing;
otherwise, connect to the right context.

## Step 2: Creating the new deployment

The following steps are identical to those for
[deploying the primary Coder installation](../../setup/installation.md).

First, [update your Helm chart](../../guides/admin/helm-charts.md) to set the
following required values:

- `coderd.satellite.enable` - set to `true`
- `coderd.satellite.primaryURL` - set with the primary Coder deployment access
  URL
- `coderd.satellite.accessURL` - set with the URL you want to use to access the
  satellite deployment

The following is a sample `values.yaml` for a deployment with satellites, TLS,
and dev URLs enabled:

```yaml
coderd:
  satellite:
    enable: "true"
    primaryURL: "https://coder.example.com"
    accessURL: "https://coder-eu-west.example.com"
  devurlsHost: "*.coder-eu-west.example.com"
  tls:
    hostSecretName: "coder-satellite-cert"
    devurlsHostSecretName: "coder-satellite-cert"
```

Once you've updated your Helm chart, install the satellite:

```console
helm repo add coder https://helm.coder.com
helm repo update
helm upgrade coder-satellite coder/coder \
  --namespace=<NAMESPACE>
  --version=<CODER_VERSION> \
  --install \
  -f values.yaml
```

## Step 3: Registering the satellite

Once you've deployed the satellite, you need to register it to the primary Coder
deployment. This process ensures that the primary deployment can trust requests
originating from the satellite deployment.

Using the Coder CLI, run:

```bash
coder satellites create <NAME> <SATELLITE_ACCESS_URL>
```

This command will fetch the public key from satellite deployment and register it
with Coder. If successful, the satellite deployment should be fully functional
and reachable via the provided access URL.

## Viewing Satellites

You can list your satellite deployments using the Coder CLI:

```console
coder satellites ls
```

## Removing a Satellite

You can remove your satellite deployments using the Coder CLI:

```console
coder satellites rm <NAME_OF_SATELLITE>
```

After removing a registered satellite deployment via the Coder CLI, you should
remove the deployment via Helm as well:

```bash
helm uninstall coder-satellite -n <NAMESPACE>
```
