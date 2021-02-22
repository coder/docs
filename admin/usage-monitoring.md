---
title: Usage Monitoring
description: Learn how to monitor Coder's compute usage.
---

We recommend monitoring your Coder deployment to track compute cost,
performance, uptime, and deployment stability. Because Coder is
deployed onto Kubernetes, you can monitor your developer workspaces as you would
any other server workload.

## Node Utilization Metrics

One of the most important metrics to track is the CPU and memory
usage/utilization of the underlying Kubernetes node. Excessive node resource
contention can result in the throttling of developer environments, while
excessive underutilization suggests that you may be spending more on your cloud
environment than necessary.

![Monitoring CPU Utilization](../assets/compute-1.png)

![Monitoring Memory Utilization](../assets/compute-2.png)

There are several tools available to you to balance the tradeoff between
environment performance and cloud cost. Read more about this on [compute
resources](resources.md).

## Development Workspace Metrics

Coder comes with a set of Kubernetes labels that allow monitoring tools to map
cluster resources to Coder's product-level resource identifiers. For example,
the following chart tracks the CPU/Memory Limit Utilization of each environment
container and labels them with the username and environment name identifiers:

![Monitoring CPU Utilization by Environment and User](../assets/compute-3.png)

![Monitoring Memory Utilization by Environment and User](../assets/compute-4.png)

These views can help you track which users may require larger CPU allocations,
enabling greater "burst-ability" under peak loads. However, remember that using
a CPU/memory provision rate greater than 1:1 may result in users being throttled
below their CPU limit if the underlying Kubernetes Node experiences CPU contention.

## Control Plane Monitoring

Monitoring the Coder control plane can help you maintain high uptime. For
example, the following charts provide high-level insight into the state of the
Coder API server:

![Monitoring Log Event Severity](../assets/compute-5.png)

![Monitoring API Status Codes](../assets/compute-6.png)

![Monitoring HTTP Latency](../assets/compute-7.png)
