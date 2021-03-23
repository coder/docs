---
title: "Requirements"
description: Learn about the prerequisite infrastructure requirements.
---

Coder is deployed onto Kubernetes clusters, and we recommend the following
resource allocation minimums to ensure quality performance.

For **basic control services**, allocate at least 2 CPU cores, 4 GB of RAM, and
20 GB of storage.

For **each** active developer, please allocate an additional CPU core, 1 GB of
RAM, and 10 GB of storage on top of the resources allocated for basic control
services.

We recommend the following throughput:

- Read: 3000 IOPS at 50 MB/s
- Write: 3000 IOPS at 50 MB/s

## Enabled Extensions

You must enable the following extensions on your K8 cluster (check whether you
have these extensions enabled by running `kubectl get apiservices`):

- apps/v1
- rbac.authorization.k8s.io/v1
- metrics.k8s.io
- storage.k8s.io/v1
- networking.k8s.io/v1
- extensions/v1beta1

## Browsers

Use an up-to-date browser to ensure that you can use all of Coder's features. We
currently require the following versions _or newer_:

- Apple Safari 12.1
- Google Chrome 66
- Mozilla Firefox 57
- Microsoft Edge 79

If you're using [Remote IDEs](../environments/editors.md), allow pop-ups; Coder
launches the Remote IDE in a pop-up window.

## Licenses

The use of Coder deployments requires a license that's emailed to you.

### Restrictions

Deployments using the free trial of Coder:

- **Must** be able to reach and use an outbound internet connection (at minimum,
  your deployment must be able to access **licensor.coder.com**)
- Cannot be deployed in an air-gapped network
- Must use Coder v1.10.0 or later

The above requirements do not apply to potential customers engaged in our
evaluation program.
