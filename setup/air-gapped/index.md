---
title: Air-Gapped Deployment
description: Learn how to set up an air-gapped Coder deployment.
---

If you need increased security for your Coder deployments, you can set up an
air-gapped deployment.

To do so, you must:

- Pull all Coder deployment resources into your air-gapped environment
- Push the images to your Docker registry,
- Deploy Coder from within your air-gapped environment

> Coder licenses issued as part of the trial program do not support air-gapped
> deployments.

## Dependencies

Before proceeding, please ensure that you've installed the following software
dependencies:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://helm.sh/docs/intro/install/)

Next, configure the following items in the same network as the Kubernetes
cluster that will run Coder (we've provided links to a suggested option for each
item type, but you're welcome to use the alternatives of your choice):

- [Docker Registry](https://hub.docker.com/_/registry)
- A [DNS server](https://coredns.io) (or you can use
  [HostAliases](https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/))
- A
  [certificate authority](https://github.com/activecm/docker-ca/blob/master/Dockerfile)
  or [self-signed certificates](#self-signed-certificate-for-the-registry)

## Network configuration

Coder requires several preliminary steps to be performed on your network before
you can deploy Coder. If don't already have the following on your network,
please see our [infrastructure setup guide](infrastructure.md):

- A certificate authority
- A domain name service
- A local Docker Registry

## Version controlling your changes to the Coder install files

Throughout this article, we will suggest changes to the Helm chart that you'll
obtain from the `.tgz` that's returned when you run `helm pull`. We recommend
version controlling your files.

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
   `coder-X.Y.Z.tgz` (X.Y.Z is the Coder release number).

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

   To access Coder, you'll need an ingress controller; you can use
   [nginx-ingress-controller](https://quay.io/kubernetes-ingress-controller/nginx-ingress-controller),
   or you can use your own.

   The following images are optional, though you're welcome to take advantage of
   Coder's versions instead of building your own:

   [OpenVSX](https://github.com/orgs/eclipse/packages/container/package/openvsx-server)

   [enterprise-node](https://hub.docker.com/r/codercom/enterprise-node)

   [enterprise-intellij](https://hub.docker.com/r/codercom/enterprise-intellij)

   [ubuntu](https://hub.docker.com/_/ubuntu)

   When building images for your environments that rely on a custom certificate
   authority, be sure to follow the
   [docs for adding certificates](/docs/images/ssl-certificates#adding-certificates-for-coder)
   to images.

1. Tag and push all of the images that you've downloaded in the previous step to
   your internal registry; this registry must be accessible from your air-gapped
   environment. For example, to push `coder-service`:

   ```console
   docker tag coderenvs/coder-service:<version> my-registry.com/coderenvs/coder-service:<version>
   docker push my-registry.com/coderenvs/coder-service:<version>
   ```

1. Modify the image used for the ingress controller. In `coder-X.Y.Z.tgz`, which
   you obtained by running `helm pull`, find the `templates/ingress.yaml` file.
   You'll see that this file has only one instance of `image:`. Replace this
   line:

   ```yaml
   quay.io/kubernetes-ingress-controller/nginx-ingress-controller:<version>
   ```

   with the image for your local ingress controller image:

   ```yaml
   <your_registry>/nginx-ingress-controller:<version>
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

   If you'd like to run this command after navigating _into_ the `coder.tgz`
   directory, you can replace the `coder.tgz` path with a period:

   ```bash
   helm install --wait --atomic --debug --namespace coder coder . \
      --set cemanager.image=$REGISTRY_DOMAIN_NAME/coderenvs/coder-service:<version> \
      --set envproxy.image=$REGISTRY_DOMAIN_NAME/coderenvs/coder-service:<version> \
      --set envbox.image=$REGISTRY_DOMAIN_NAME/coderenvs/envbox:<version> \
      --set envbuilder.image=$REGISTRY_DOMAIN_NAME/coderenvs/envbuilder:<version> \
      --set timescale.image=$REGISTRY_DOMAIN_NAME/coderenvs/timescale:<version> \
      --set dashboard.image=$REGISTRY_DOMAIN_NAME/coderenvs/dashboard:<version> \
      -f registry-cert-values.yml
   ```

1. Next, follow the [Installation](installation.md) guide beginning with **step
   6** to get the access URL and the temporary admin password, which allows you
   to proceed with setting up and configuring Coder.

## Extensions marketplace

You can configure your deployment to use the internal, built-in extension
marketplace, allowing your developers to utilize whitelisted IDE extensions
within your air-gapped environment. For additional details, see
[Extensions](../admin/environment-management/extensions.md).
