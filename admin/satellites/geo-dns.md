---
title: GeoDNS
description: |
    Learn how to configure your primary and satellite deployments so that they share a
    hostname.
state: alpha
---

By default, the primary deployment and satellite deployments have different
access URLs. The use of two access URLs can confuse engineering
teams when it comes time to determine which access URL they should use to access
Coder.

To fix this, Coder supports a GeoDNS configuration where the primary deployment
and all satellite deployments share a hostname. All users who access Coder use the
same URL while still accessing a deployment that offers low latency when
connecting to their workspaces.

> We recommend maintaining separate access URLs for each primary and satellite
> deployment alongside the new uniform GeoDNS access URL. This allows you to
> access specific deployments while avoiding GeoDNS if necessary in the future.
> This guide will walk you through the process of preserving both URLs for your
> deployments.

## Requirements

You will need the following:

- A primary access URL (e.g. `https://primary.example.com`).
- One or more satellite access URLs (e.g. `https://sydney.example.com`,
  `https://london.example.com`).
- A GeoDNS load balancer and its access URL (e.g. `https://coder.example.com`).
You should set the default backend to the primary access URL or IP address. Set
the backend for each region with a satellite to the corresponding satellite
access URL or IP address.
- A TLS certificate for the primary deployment that has both the primary
  hostname and the corresponding GeoDNS hostname
- A TLS certificate for *each* satellite with the satellite's hostname and the
  corresponding GeoDNS hostname

### Notes

- We have provided instructions on [how to create a GeoDNS load balancer on
  Cloudflare](#create-a-geodns-load-balancer-on-cloudflare) below.
- If you are using cert-manager, you can add hostnames to a certificate by
  including them in the `spec.dnsNames` section.

## Configure GeoDNS on Coder

1. In the primary Helm values file, set `coderd.alternateHostnames` to your
   primary hostname and your GeoDNS hostname:

   ```yaml
   coderd:
     alternateHostnames:
       - "primary.example.com"
       - "coder.example.com"
   ```

1. In *each* of your satellite deployments' Helm values file:

    1. Set `coderd.satellite.accessURL` to your primary access URL, which is the
       name of the global load balancer in front of Coder deployments (this
       value will be used as the default URL)

    1. Set `coderd.alternateHostnames` to your satellite's specific hostname and
       your GeoDNS hostname:

       ```yaml
       coderd:
         alternateHostnames:
           - "satellite.example.com"
           - "coder.example.com"
       ```

1. Deploy your primary and satellite deployments with your new Helm values.

1. Once you've fully deployed your primary and satellite deployments, log into
   Coder, and go to **Manage** > **Admin**.

1. On the **Infrastructure** tab, set the **Access URL** field to your GeoDNS
   access URL (e.g. `https://coder.example.com`).

1. If you've enabled logins via OIDC, log into your OIDC identity provider's
   admin page and update Coder's redirect URI to reflect your new access URL
   (e.g. `https://coder.example.com/oidc/callback`)

At this point, all users should be able to access Coder. Coder will
automatically route users to their nearest geographical satellite via your GeoDNS
access URL. OIDC logins should work as expected across all domain names,
including the primary access URL.

## Create a GeoDNS load balancer on Cloudflare

To create a GeoDNS load balancer on Cloudflare:

1. Log in to Cloudflare, and select the domain on which you want your GeoDNS
   hostname to exist.

1. Expand the **Traffic** app on the sidebar and select **Load Balancing**.

1. Enable **Load Balancing** if you haven't already

1. Ensure that your Cloudflare plan has enough origin servers for your
   deployments; you will need one origin server for the primary deployment and
   one for each satellite deployment.

1. Click **Create Load Balancer**.

1. Enter the GeoDNS hostname you wish to use (e.g.
   `https://coder.example.com`).

   ![Enter hostname](../../assets/admin/cloudflare-geodns/hostname.png)

1. **Optional:** Disable Cloudflare proxying by unchecking the orange cloud. We
      recommend disabling Cloudflare proxying when using satellites, since
      proxying adds additional hops that will increase latency.

1. Click **Next** to proceed.

1. For the primary deployment and *each* satellite deployment, do the
   follow steps:

    1. Click **+ Create an Origin Pool**.

    1. Set the **Pool Name** and **Pool Description**.

    1. Specify a single origin with **Origin Address** set to the hostname or IP
       address of the deployment. Then, set the **Weight** to **1**.

    1. Click **Configure co-ordinates for Proximity Steering** and drag the
       marker to roughly where the deployment is located geographically.

    1. Click **Save**.

      ![Create pool](../../assets/admin/cloudflare-geodns/create-pool.png)

1. Once you have completed the above steps for the primary and each
   satellite deployment,
   ensure that all origin pools have been assigned to the load balancer.

1. Set the **Fallback Pool** to your primary deployment's origin pool.

   ![Pools](../../assets/admin/cloudflare-geodns/pools.png)

1. Click **Next** until you reach the **Traffic Steering** step.

1. Set the traffic steering policy to **Proximity steering**.

1. Click **Next** until you reach the **Review** step.

1. Review your changes; then, click **Save and Deploy**.
