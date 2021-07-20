---
title: Satellites
description: Learn about satellite deployments to reduce global latency.
---

Using Workspace Providers, a single Coder deployment can provision and manage
workspaces across multiple Kubernetes clusters and namespaces, including those
located in other geographies, regions, or clouds. Satellites are coder
deployments that are used as access points to workspaces provisioned in a
multi-region pattern. Satellites reduce latency for developers by acting as
local proxies to the workspaces, keeping the traffic from the developer's
machine to the workspaces all within the same region instead of needing to cross
regions back to the primary coder deployment.

[insert illustration here]

Satellites function as a secure reverse proxy to both the Coder workspaces and
the primary Coder deployment. Traffic meant to reach the workspaces, such web
and SSH connections, will be sent directly to the workspaces while all other
traffic goes to the primary Coder deployment. Users of Coder connect to the
satellite deployment that is geographically closest to them over the primary
deployment to gain the benefits of the local proxying.

## Geographic DNS

Because it's always beneficially for developers to connect to the deployment
closest to them for the lowest latency, DNS features such as anycast, GeoDNS, or
GeoIP can be used to collect the coder deployments under a single hostname for a
better developer experience. An example set of records with these features
enabled could be:

```text
CNAME coder.example.com coder-us-east.example.com
CNAME coder.example.com coder-us-west.example.com
CNAME coder.example.com coder-eu-west.example.com
CNAME coder.example.com coder-ap-southeast.example.com

A coder-us-east.example.com      xxx.xxx.xxx.xxx
A coder-us-west.example.com      xxx.xxx.xxx.xxx
A coder-eu-west.example.com      xxx.xxx.xxx.xxx
A coder-ap-southeast.example.com xxx.xxx.xxx.xxx
```

Then developers can connect to `https://coder.example.com` and be serviced by
the correct replica deployment based off the developer's location.

## Creating a Satellite

Creating a new satellite includes deploying the coder helm chart with the
`satellite` mode enabled and using the Coder CLI to register the new deployment.

## Dependencies

Install the following dependencies if you haven't already:

- [Coder CLI](../../cli/installation.md)
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Requirements

1. Authenticated with coder-cli with a Site Manager role.
1. The satellite deployment must be able to reach the primary coder deployment
   on HTTP(S).

## Connecting to the cluster

You must first make sure that you're connected to the cluster you want to deploy
the coder satellite into. This deployment should ideally be in the same
geographical region as both the developers and the workspaces. Run the following
command:

```bash
kubectl config current-context
```

Confirm that your current kubectl context correct before continuing; otherwise,
connect to the correct context.

## Creating the new workspace provider

Following the same steps to deploy the primary Coder installation, deploy the
helm chart with the following required values set:

- `coderd.satellite.enable` - must be `true`
- `coderd.satellite.primaryURL` - must be set to the primary Coder deployment
  access URL
- `coderd.satellite.accessURL` - must be set to the URL used to access the
  satellite deployment

An example set of helm values for a deployment with tls and devurls enabled:

```yaml
coderd:
  satellite:
    enable: "true"
    primaryURL: "https://coder.example.com"
    accessURL: "https://eu-west.example.com"
  devurlsHost: "*.eu-west.example.com"
  tls:
    hostSecretName: "coder-satellite-cert"
    devurlsHostSecretName: "coder-satellite-cert"
```

## Registering the Satellite

Once the coder satellite has been deployed, it needs to be registered to the
primary Coder deployment. This process ensures we can trust the requests coming
from the satellite deployment.

Using the Coder CLI, create a new satellite deployment:

```bash
coder satellites create [NAME] [SATELLITE_ACCESS_URL]
```

This command will fetch the public key from satellite deployment and register it
with Coder. Upon success the satellite deployment should be fully functional and
reachable via the provided access URL.

## Viewing Satellites

Using the Coder CLI, list the satellite deployments:

```bash
coder satellites ls
```

## Removing a Satellite

Using the Coder CLI, remove the satellite deployment:

```bash
coder satellites rm [NAME]
```

After removing a registered satellite deployment from Coder, the helm deployment
should also be removed.
