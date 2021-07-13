---
title: "Red Hat OpenShift"
description: Learn about deploying Coder in OpenShift Container Platform
---

This deployment guide shows you how to customize your [OpenShift Container
Platform] cluster in order to deploy Coder. The OpenShift Container Platform
includes default security features, notably the `restricted` [Security Context
Constraint], which can interfere with applications, including Coder.

This guide describes customizations to the OpenShift cluster as well as Coder
that ensure an optimal user experience.

[OpenShift Container Platform]: https://www.openshift.com/products/container-platform
[Security Context Constraint]: https://docs.openshift.com/container-platform/4.7/authentication/managing-security-context-constraints.html

## Prerequisites

- An OpenShift cluster with a Project (Kubernetes namespace) for Coder
- OpenShift command-line tools (`oc` and `kubectl`)

## Option 1: Add the environments service account to anyuid or nonroot

Coder's default base images for workspaces, such as `enterprise-base`, run as
the `coder` user (UID 1000). By default, the OpenShift platform does not
allow running with this user, as service accounts use the `restricted` Security
Context Constraint by default, and must run with a project-specific UID.

Coder creates workspaces in pods with the service account `environments`, and
we recommend adding this service account to the `anyuid` or `nonroot` Security
Context Constraint using:

```console
$ oc adm policy add-scc-to-user nonroot -z environments
clusterrole.rbac.authorization.k8s.io/system:openshift:scc:nonroot added: "environments"
$ oc adm policy who-can use scc nonroot
resourceaccessreviewresponse.authorization.openshift.io/<unknown> 

Namespace: coder
Verb:      use
Resource:  securitycontextconstraints.security.openshift.io

Users:  system:admin
        system:serviceaccount:coder:environment
```

## Option 2: Build images compatible with OpenShift

In order to run Coder workspaces without modifying Security Context Constraints,
you can modify the user and permissions from the base images. First, determine
the UID range for the project using:

```console
$ oc describe project coderName:                   coder
Created:                10 days ago
Labels:                 <none>
Annotations:            openshift.io/description=
                        openshift.io/display-name=
                        openshift.io/requester=kube:admin
                        openshift.io/sa.scc.mcs=s0:c26,c10
                        openshift.io/sa.scc.supplemental-groups=1000670000/10000
                        openshift.io/sa.scc.uid-range=1000670000/10000
Display Name:           <none>
Description:            <none>
Status:                 Active
Node Selector:          <none>
Quota:                  <none>
Resource limits:        <none>
```

Create a `BuildConfig` that outputs an image with a UID in the given range
(in this case, sa.scc.uid-range begins with 1000670000):

```yaml
kind: BuildConfig
apiVersion: build.openshift.io/v1
metadata:
  name: example
  namespace: coder
spec:
  triggers:
    - type: ConfigChange
  runPolicy: Serial
  source:
    type: Dockerfile
    dockerfile: |
      FROM docker.io/codercom/enterprise-base:ubuntu

      # Switch to root
      USER root 

      # As root, change the coder user id
      RUN usermod --uid=1000670000 coder

      # Go back to the user 'coder'
      USER coder
  strategy:
    type: Docker
    dockerStrategy:
      imageOptimizationPolicy: SkipLayers
  output:
    to:
      kind: ImageStreamTag
      name: 'enterprise-base:latest'
```

When creating workspaces, [configure Coder to connect to the internal OpenShift
registry](../../admin/registries/index.md) and use this base image.
