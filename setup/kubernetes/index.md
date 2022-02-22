---
title: Kubernetes
description: Learn how to set up a Kubernetes cluster compatible with Coder.
---

This section contains guides for creating a compatible cluster on common cloud
platforms, including Microsoft Azure, Google Cloud Platform, and Amazon Web
Services. If you already have a Kubernetes cluster that meets Coder's
[requirements](../requirements.md), you can proceed to the [installation guide].

## Supported Kubernetes versions

You can deploy Coder to any [compatible Kubernetes cluster]. Coder follows the
[Kubernetes upstream version support policy], and the latest stable release
version of Coder supports the previous two minor releases as well as the current
release of Kubernetes at time of publication.

> During installation, Helm will check to ensure that Coder is compatible with
> your cluster version; if not, the installation process will fail, and you will
> receive an error message indicating the minimum cluster version required.

Coder continuously removes usage of deprecated Kubernetes API versions once the
minimum baseline version of Kubernetes supports the necessary features in a
stable version. We follow this policy to ensure that Coder stops using
deprecated features before they are removed from new versions of Kubernetes.

<!-- markdownlint-disable -->

|              | Kubernetes `1.23` | Kubernetes `1.22` | Kubernetes `1.21` | Kubernetes `1.20` | Kubernetes `1.19` | Kubernetes `1.18` |
| ------------ | ----------------- | ----------------- | ----------------- | ----------------- | ----------------- | ----------------- |
| Coder `1.28` | ✅                | ✅                | ✅                |                   |                   |                   |
| Coder `1.27` | ✅                | ✅                | ✅                |                   |                   |                   |
| Coder `1.26` |                   | ✅                | ✅                | ✅                |                   |                   |
| Coder `1.25` |                   | ✅                | ✅                | ✅                |                   |                   |
| Coder `1.24` |                   |                   | ✅                | ✅                | ✅                |                   |
| Coder `1.23` |                   |                   | ✅                | ✅                | ✅                |                   |
| Coder `1.22` |                   |                   |                   | ✅                | ✅                | ✅                |

[compatible kubernetes cluster]: ../requirements.md
[kubernetes upstream version support policy]:
  https://kubernetes.io/docs/setup/release/version-skew-policy/
[installation guide]: ../installation.md

<!-- markdownlint-restore -->

<children></children>

## Incompatible Kubernetes distributions

- [DigitalOcean Kubernetes](https://www.digitalocean.com/products/kubernetes/)
  does not support Coder with [CVMs](../../admin/workspace-management/cvms).
- The [OpenShift Container Platform](openshift.md) does not support Coder with
  [CVMs](../../admin/workspace-management/cvms).
