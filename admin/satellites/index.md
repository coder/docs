---
title: Satellites
description: Learn about satellite deployments to reduce global latency.
---

Workspace providers allow a single Coder deployment to provision and manage
workspaces across multiple Kubernetes clusters and namespaces, including those
located in other geographies, regions, or clouds.

Satellites are Coder deployments that are used as access points to workspaces
provisioned in a multi-region pattern. Satellites reduce latency for developers
by acting as local proxies to the workspaces, keeping traffic from the
developer's machine to the workspaces within the same region instead of
requiring the traffic to cross regions back to the primary Coder deployment.

Satellites, on the other hand, act as a secure reverse proxy to both Coder
workspaces and the primary Coder deployment. Traffic meant for workspaces, such
as web and SSH connections, are sent directly to the workspaces, while all other
traffic is routed to the primary Coder deployment.

![Satellites](https://user-images.githubusercontent.com/19379394/126407423-35bc00c3-e40b-4f98-a130-b144085a6daa.png)

Coder users connect to the satellite deployment that's geographically closest to
them instead of to the primary deployment, gaining the benefits of local
proxying.

## Geographic DNS

Because it's beneficial for developers to connect to the deployment closest to
them (a practice that gets them the lowest latency), you can use DNS features
such as Anycast, GeoDNS, and GeoIP to collect Coder deployments under a single
hostname for a better developer experience. A sample set of records with such
features enabled might look like this:

```text
CNAME coder.example.com coder-primary.example.com
CNAME coder.example.com coder-us-west.example.com
CNAME coder.example.com coder-eu-west.example.com
CNAME coder.example.com coder-ap-southeast.example.com

A coder-primary.example.com      xxx.xxx.xxx.xxx
A coder-us-west.example.com      xxx.xxx.xxx.xxx
A coder-eu-west.example.com      xxx.xxx.xxx.xxx
A coder-ap-southeast.example.com xxx.xxx.xxx.xxx
```

Developers can then connect to `https://coder.example.com` while still being
serviced by the deployment that's closest.
