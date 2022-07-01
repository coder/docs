---
title: Prometheus integration
description: Learn how to configure Prometheus with Coder.
---

The Prometheus integration enables you to query and visualize Coder's platform
metrics.

## Requirements

- A Coder deployment on Kubernetes
- [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator)
installed on your cluster

## Configuration

Coder sends Prometheus-formatted metrics to port `2112` on the `coderd`
container. Use the below PodMonitor resource to connect the Prometheus Operator
to this endpoint:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: master-monitor
  namespace: coder
spec:
  selector:
    matchLabels:
      app.kubernetes.io/component: coderd
  podMetricsEndpoints:
    - port: prom-coderd
```
