---
title: Hosted beta
description: Get started with a hosted Coder deployment.
---

This guide helps you understand how Coder's hosted beta offering works and how
you can access your deployment to get started.

## What is Coder's hosted beta offering?

The hosted beta offering is a hybrid cloud offering of Coder's self-hosted
platform. Coder hosts the control plane, while you host your compute and
development workspaces. The benefits of this setup include:

- Automatic upgrades
- No DNS or TLS configuration
- Managed logging and monitoring

If you are interested in trying the hosted beta,
[contact us](https://coder.com/contact?note=I%20would%20like%20to%20try%20the%20hosted%20offer.%0A%0ANumber%20of%20developers%3A%0A%0AUse%20case%3A)).

## How the hosted beta works

Curious how the hosted beta works? Here's a breakdown of the underlying
architecture.

### Coder infrastructure

- The `coderd` service: responsible for rendering the dashboard UI, provisioning
  workspaces, user authentication, and many more functions.
  - Your `coderd` instance is _not_ shared across other Coder accounts. Each
    deployment has its own `coderd` instance.
- A PostgreSQL database: stores metadata related to your Coder instance, such as
  user information, session tokens, etc.

### Your infrastructure

- A Kubernetes cluster: hosts your Coder workspaces, as well as your source code
  (your source code is stored on
  [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
  mounted to each workspace pod)

`coderd` connects to your infrastructure via a service account created in your
cluster, enabling you to create workspaces.

## Accessing your Coder hosted beta

1. Navigate to your deployment URL (e.g., `<your-name>.coder.com`).

1. Log in with the email address you provided to Coder the password Coder
   provided you.

1. Once you've logged in, you'll be prompted to change your temporary password.

You're in! At this point, you'll need to
[create a Kubernetes cluster](../../setup/kubernetes/index.md) (if you don't
already have one you'd like to use with Coder) and
[connect the cluster to Coder](../../admin/workspace-providers/deployment.md)
before you can create workspaces.
