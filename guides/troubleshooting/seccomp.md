---
title: ValidationError during install
description: Learn how to fix a ValidationError during a Coder install
---

When installing or upgrading Coder, you may come across the following error:

```console
Error: unable to build kubernetes objects from release manifest: error validating "": error validating data: [ValidationError(Deployment.spec.template.spec.containers[0].securityContext): unknown field "seccompProfile" in io.k8s.api.core.v1.SecurityContext, ValidationError(Deployment.spec.template.spec.initContainers[0].securityContext): unknown field "seccompProfile" in io.k8s.api.core.v1.SecurityContext, ValidationError(Deployment.spec.template.spec.securityContext): unknown field "seccompProfile" in io.k8s.api.core.v1.PodSecurityContext]
```

## Why this happens

You will receive this error if you're attempting to install a Coder version
1.21 or greater on a Kubernetes cluster using version 1.18 or earlier. This
is due to Kubernetes version 1.18 not supporting the security policy
configurations in Coder's 1.21 Helm chart.

## Solutions

You have two options to solve this error:

1. Upgrade your Kubernetes cluster to version 1.19 or greater.

1. Remove the struck-through lines and set the `podSecurityContext` and
   `securityContext` values to `null`:

```yaml
   podSecurityContext: null
    ~~runAsNonRoot: true~~
    ~~runAsUser: 1000~~
    ~~seccompProfile:~~
      ~~type: RuntimeDefault~~
  securityContext: null
    ~~readOnlyRootFilesystem: true~~
    ~~seccompProfile:~~
      ~~type: RuntimeDefault~~
    ~~allowPrivilegeEscalation: false~~
```

If this doesn't resolve the issue, please
[contact us](https://coder.com/contact) for further support.
