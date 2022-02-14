---
title: GeoDNS
description: |
    Learn how to configure your primary and satellite deployments to share a
    single hostname.
state: alpha
---

Out of the box, satellites deployments have a different access URL to the
primary deployment. This may cause confusion for engineering teams located
globally. This may cause confusion amongst users wondering which access URL they
should access Coder from.

Coder supports a GeoDNS configuration where all satellites and the primary
deployment share the same hostname, so all users access Coder using a consistent
URL but maintain low latency to their workspaces.

> We recommend maintaining separate access URLs for each satellite and primary
> deployment alongside the new GeoDNS access URL so you can access specific
> deployments while avoiding GeoDNS in the future. This guide will walk you
> through this configuration process.

## Requirements

You will need the following:

- A primary access URL (e.g. `https://primary.example.com`).
- One or more satellite access URLs (e.g. `https://sydney.example.com`,
  `https://london.example.com`).
- A GeoDNS load balancer access URL (e.g. `https://coder.example.com`). The
  default backend should be set to the primary access URL or IP address. The
  backend for each region with a satellite should be set to the satellite access
  URL or IP address.
- The TLS certificate used by the primary must have both the primary hostname
  and the GeoDNS hostname
- The TLS certificate used by each satellite must have the satellite's hostname
  and the GeoDNS hostname

> If you are using cert-manager, you can easily add more hostnames to your
> certificate by adding them to the `spec.dnsNames` section.

To create a GeoDNS load balancer on Cloudflare, you can refer to our simple
instructions [below](#create-a-geodns-load-balancer-on-cloudflare).

## Configure GeoDNS on Coder

To configure GeoDNS on Coder:

1. In the primary helm values file, set `coderd.alternateHostnames` to your
   primary hostname and your GeoDNS hostname:

   ```yaml
   coderd:
     alternateHostnames:
       - "primary.example.com"
       - "coder.example.com"
   ```

1. In each satellite helm values file:
    1. Set `coderd.satellite.accessURL` to your primary access URL, which is the name of the global load balancer in front of Coder deployments (this value is used
       as the default URL)
    1. Set `coderd.alternateHostnames` to your satellite's specific hostname and
       your GeoDNS hostname:

       ```yaml
       coderd:
         alternateHostnames:
           - "satellite.example.com"
           - "coder.example.com"
       ```

1. Deploy your primary and satellites with your new Helm values.
1. Once fully deployed and rolled out, log into Coder.
1. Go to Manage > Admin.
1. Set the **Access URL** field to your GeoDNS access URL (e.g.
   `https://coder.example.com`).
1. If using OIDC, log into your OIDC identity provider's admin page and update
   Coder's redirect URI to the new access URL (e.g.
   `https://coder.example.com/oidc/callback`)

All users should be able to access Coder and be routed to their nearest
geographical satellite using your GeoDNS access URL. OIDC login should work as
expected across all domain names, including the primary

## Create a GeoDNS load balancer on Cloudflare

To create a GeoDNS load balancer on Cloudflare:

1. Login to the Cloudflare dashboard and select the domain you want your GeoDNS
   hostname to exist on.
1. Expand the **Traffic** app on the sidebar and select **Load Balancing**.
1. Enable **Load Balancing** if it has not already been enabled on your account
1. Ensure your Cloudflare plan has enough origin servers for your deployments,
   you will need one origin server for the primary and each satellite.
1. Click **Create Load Balancer**.
1. Enter the GeoDNS hostname you wish to use (e.g.
   `https://coder.example.com`).
   ![Enter hostname](../../assets/admin/cloudflare-geodns/hostname.png)
1. *Optional:* disable Cloudflare proxying by unchecking the orange cloud.
    - We recommend disabling Cloudflare proxying when using satellites as it
      adds extra hops which will increase latency, since the satellite is
      usually nearby the user anyways
1. Click **Next**.
1. For the primary and each satellite do the following:
    1. Click the **+ Create an Origin Pool** link
    1. Set the **Pool Name** and **Pool Description**
    1. Specify a single origin with **Origin Address** set to the hostname or IP
       of the deployment and set the **Weight** to `1`
    1. Click **Configure co-ordinates for Proximity Steering** and drag the
       marker to roughly where the deployment is located geographically
    1. Click **Save**
   ![Create pool](../../assets/admin/cloudflare-geodns/create-pool.png)
1. Once you have completed the above step for the primary and each satellite,
   ensure that all of the origin pools have been assigned to the load balancer.
1. Set the **Fallback Pool** to your primary deployment's origin pool.
   ![Pools](../../assets/admin/cloudflare-geodns/pools.png)
1. Click **Next** until you reach the **Traffic Steering** step.
1. Set the traffic steering policy to **Proximity steering**.
1. Click **Next** until you reach the **Review** step.
1. Review your changes, and then click **Save and Deploy**.
