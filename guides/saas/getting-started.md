---
title: Getting started with Coder's hosted beta
description: Get started with a hosted Coder deployment.
---

To help you get started, we've put together this guide to help you understand
how the Coder hosted beta works and how to access your deployment.

## What is Coder hosted beta?

The Coder hosted beta is a hybrid cloud offering of Coder's self-hosted
platform. With this model, Coder hosts the control plane, and you host your
compute and development workspaces. The benefits include:

- Automatic upgrades
- No installation or DNS configuration
- Managed logging & monitoring

If you interested in trying the limited beta, [contact us](https://coder.com/contact?note=I%20would%20like%20to%20try%20the%20hosted%20offer.%0A%0ANumber%20of%20developers%3A%0A%0AUse%20case%3A))

Curious how this works? Here's a breakdown of the architecture:

**Coder's infrastructure**:

- The `coderd` service - Responsible for rendering the dashboard UI,
  provisioning workspaces and user authentication, including a variety of other functions
  - Your `coderd` instance is _not_ shared across other Coder accounts. Each deployment
      receives their own `coderd` instance
- A PostgreSQL DB - Stores metadata related to your Coder instance,
  such as user information, session tokens, etc.
  - Coder uses a single PostgreSQL instance with each deployment having their
    own database within the instance

**Your infrastructure**:

- Kubernetes cluster - Hosts your Coder workspaces, in addition to your source
  code, which is stored on [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
  that are mounted to each workspace pod

`coderd` connects to your infrastructure through a service account created in
your cluster, enabling you to create workspaces in your cluster.

## Accessing your Coder hosted beta

1. Navigate to your deployment URL and login with the following credentials:

   - Deployment URL should be `<your-name>.coder.com`

   - Username should be `admin`

   - Password should be similar to `Lv7...k3`

> These credentials are emailed to your Coder admin.

1. Once logged in, you'll be prompted to change your temporary password

1. Enter the license file provided to you by email

You're in! Now that you've successfully accessed your hosted Coder deployment,
it's time to connect your Kubernetes cluster to Coder. See our guide on creating
a workspace provider (insert link here).
