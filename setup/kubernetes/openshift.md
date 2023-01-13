---
title: "Red Hat OpenShift"
description: Learn about deploying Coder in OpenShift Container Platform
---

This deployment guide shows you how to customize your [OpenShift Container
Platform] cluster to deploy Coder.

The OpenShift Container Platform includes security features, notably the
restricted [Security Context Constraint] (SCC), that can interfere with Coder.
This guide describes the customizations to the OpenShift cluster and Coder that
ensure an optimal user experience.

[openshift container platform]:
  https://www.openshift.com/products/container-platform
[security context constraint]:
  https://docs.openshift.com/container-platform/4.7/authentication/managing-security-context-constraints.html

> Please note that OpenShift doesn't support the use of
> [CVMs](../../admin/workspace-management/cvms/index.md)

## Prerequisites

- An OpenShift cluster with a project (Kubernetes namespace) for Coder
- OpenShift command-line tools (`oc` and `kubectl`) installed

## Step 1: Modify pod and container security contexts

OpenShift's SCC feature enforces the settings with which applications must run.
The default SCC setting, `restricted`, requires applications to run as a user
within a project-specific range (`MustRunAsRange`) and does not allow apps to
define a seccomp profile.

You can view the restrictions using `oc describe scc restricted`:

```console
$ oc describe scc restricted
Name:                                           restricted
Priority:                                       <none>
Access:
  Users:                                        <none>
  Groups:                                       system:authenticated
Settings:
  Allow Privileged:                             false
  Allow Privilege Escalation:                   true
  Default Add Capabilities:                     <none>
  Required Drop Capabilities:                   KILL,MKNOD,SETUID,SETGID
  Allowed Capabilities:                         <none>
  Allowed Seccomp Profiles:                     <none>
  Allowed Volume Types:                         configMap,downwardAPI,emptyDir,persistentVolumeClaim,projected,secret
  Allowed Flexvolumes:                          <all>
  Allowed Unsafe Sysctls:                       <none>
  Forbidden Sysctls:                            <none>
  Allow Host Network:                           false
  Allow Host Ports:                             false
  Allow Host PID:                               false
  Allow Host IPC:                               false
  Read Only Root Filesystem:                    false
  Run As User Strategy: MustRunAsRange
    UID:                                        <none>
    UID Range Min:                              <none>
    UID Range Max:                              <none>
  SELinux Context Strategy: MustRunAs
    User:                                       <none>
    Role:                                       <none>
    Type:                                       <none>
    Level:                                      <none>
  FSGroup Strategy: MustRunAs
    Ranges:                                     <none>
  Supplemental Groups Strategy: RunAsAny
    Ranges:                                     <none>
```

You can override the default settings by defining the following in your
[Helm chart](../../guides/admin/helm-charts.md):

```yaml
coderd:
  podSecurityContext:
    runAsUser: null
    seccompProfile: null
  securityContext:
    seccompProfile: null
```

At this point, you need to get your Coder workspaces running with the
appropriate service account/user. There are two options available to you:

1. Adding the environment's service account to `anyuid` or `nonroot`
1. Building images compatible with OpenShift

## Option 1: Add the environment's service account to anyuid or nonroot

Coder's default base images for workspaces, such as `enterprise-base`, run as
the `coder` user (UID 1000). However, OpenShift doesn't allow this, since
service accounts are required by the `restricted` Security Context Constraint
(SCC) to run with a project-specific UID.

To work around this, we we recommend adding this service account to the `anyuid`
or `nonroot` SCC since Coder creates workspaces in pods with the service account
`environments`:

```console
$ oc adm policy add-scc-to-user nonroot -z environments
clusterrole.rbac.authorization.k8s.io/system:openshift:scc:nonroot added: "environments"

$ oc adm policy who-can use scc nonroot
resourceaccessreviewresponse.authorization.openshift.io/<unknown>

Namespace: coder
Verb:      use
Resource:  securitycontextconstraints.security.openshift.io

Users:  system:admin
        system:serviceaccount:coder:environments
```

> Note: Do not set any `service_account_annotations` values in Workspace
> Providers, as it will cause Coder to create a workspace-specific service
> account in place of the default `environments` service account.

## Option 2: Build images compatible with OpenShift

To run Coder workspaces without modifying Security Context Constraints (SCC),
you can modify the user and permissions in the base images. First, determine the
UID range for the project using:

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

Next, create a `BuildConfig` that outputs an image with a UID in the given range
(in this case, `sa.scc.uid-range` begins with `1000670000`):

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

      # As root:
      # 1) Remove the original coder user with UID 1000
      # 2) Add a coder group with an allowed UID
      # 3) Add a coder user as a member of the above group
      # 4) Fix ownership on the user's home directory
      RUN userdel coder && \
          groupadd coder -g 1000670000 && \
          useradd -l -u 1000670000 coder -g 1000670000 && \
          chown -R coder:coder /home/coder

      # Go back to the user 'coder'
      USER coder
  strategy:
    type: Docker
    dockerStrategy:
      imageOptimizationPolicy: SkipLayers
  output:
    to:
      kind: ImageStreamTag
      name: "enterprise-base:latest"
```

When creating workspaces,
[configure Coder to connect to the internal OpenShift registry](../../admin/registries/index.md)
and use the base image you just created.

## Next steps

To access Coder through a secure domain, review our guides on configuring and
using [TLS certificates](../../guides/tls-certificates/index.md).

Once complete, see our page on [installation](../installation.md).
