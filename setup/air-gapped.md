---
title: Air-gapped deployment
description: Learn how to set up an air-gapped Coder deployment.
---

If you need increased security for your Coder deployments, you can set up an
air-gapped deployment.

To do so, you must:

- Pull all Coder deployment resources into your air-gapped environment
- Push the images to your Docker registry,
- Deploy Coder from within your air-gapped environment

> Coder licenses issued as part of the trial program do not support air-gapped
> deployments. If an air-gapped deployment is a requirement for you, please
> [reach out to our team](https://coder.com/contact) to discuss a pilot.

## Dependencies

Before proceeding, please ensure that you've installed the following
dependencies:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://helm.sh/docs/intro/install/)

## Step 1: Pull all Coder resources into your air-gapped environment

Coder is deployed through [helm](https://helm.sh/docs/intro/install/), and the
platform images are hosted in Coder's Docker Hub repo.

1. Pull down the Coder helm charts by running the following in a non-air-gapped
   environment:

   ```console
   helm repo add coder https://helm.coder.com
   helm pull coder/coder
   ```

   These commands will add Coder's helm charts and pull the latest stable
   release into a tarball file whose name uses the following format:
   coder-X.Y.Z.tgz (X.Y.Z is the Coder release number).

1. Pull the images for the Coder platform from the following Docker Hub
   locations:

   [coder-service](https://hub.docker.com/r/coderenvs/coder-service)

   [envbox](https://hub.docker.com/r/coderenvs/envbox)

   [envbuilder](https://hub.docker.com/r/coderenvs/envbuilder)

   [timescale](https://hub.docker.com/r/coderenvs/timescale)

   [dashboard](https://hub.docker.com/r/coderenvs/dashboard)

   You can pull each of these images from their `coderenvs/<img-name>:<version>`
   registry location using the image's name and Coder version:

   ```console
   docker pull coderenvs/coder-service:<version>
   ```

1. Tag and push all of the images that you've downloaded in the previous step to
   your internal registry; this registry must be accessible from your air-gapped
   environment. For example, to push `coder-service`:

   ```console
   docker tag coderenvs/coder-service:<version> my-registry.com/coderenvs/coder-service:<version>
   docker push my-registry.com/coderenvs/coder-service:<version>
   ```

1. Once all of the resources are in your air-gapped network, run the following
   to deploy Coder to your Kubernetes cluster:

   ```console
   kubectl create namespace coder
   helm --namespace coder install coder /path/to/coder-X.Y.Z.tgz \
   --set cemanager.image=my-registry.com/coderenvs/coder-service:<version> \
   --set envproxy.image=my-registry.com/coderenvs/coder-service:<version> \
   --set envbuilder.image=my-registry.com/coderenvs/envbuilder:<version> \
   --set timescale.image=my-registry.com/coderenvs/timescale:<version> \
   --set dashboard.image=my-registry.com/coderenvs/dashboard:<version> \
   --set envbox.image=my-registry.com/coderenvs/envbox:<version>
   ```

1. Next, follow the [Installation](installation.md) guide beginning with **step
   6** to get the access URL and the temporary admin password, which allows you
   to proceed with setting up and configuring Coder.

## Extensions marketplace

You can configure your deployment to use the internal, built-in extension
marketplace, allowing your developers to utilize whitelisted IDE extensions
within your air-gapped environment. For additional details, see
[Extensions](../admin/environment-management/extensions.md).
