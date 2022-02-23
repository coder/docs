---
title: "Update considerations"
description: Learn how to update your Coder deployment.
---

The upgrade page provides instructions on how to upgrade your Coder deployment.
This article, however, includes information you should be aware of prior to
upgrading, such as architecture updates and breaking changes.

## Upgrading from v1.25 to v1.26

- Beginning with `1.26`, Coder requires the use of Kubernetes `1.20` or later.
  See Coder's [version support policy] for more information.

<!-- Turn off linting to avoid changing the link -->
<!-- markdownlint-disable MD044 -->

[version support policy]: ../kubernetes/index.md#supported-kubernetes-versions

- Coder supports the use of Markdown formatting in system and service banners.
  Coder now renders the Markdown content in existing banners, instead of
  displaying the raw Markdown syntax.

- Coder has made the dark theme generally available. Users who have enabled the
  beta version via feature flag will need to re-enable this; Coder won't
  auto-apply the theme.

## Upgrading from v1.24 to v1.25

- In 1.25, dev URLs use double dashes `--` as delimiters, instead of single
  dashes `-`. Please update bookmarks accordingly.

- v1.25 updates the username format to allow the use of alphanumeric character
  and hyphens. The length of the username can be 1-39 characters, inclusive.

## Upgrading from versions prior to v1.21

Users upgrading deployments that predate the release of v1.21 to v1.21 or later
should update their Helm values file to reflect Coder's [updated schema]. More
specifically, users must change the following values:

- `cemanager` --> `coderd`
- `cemanager.replicas` --> `coderd.replicas`
- `cemanager.image` --> `coderd.image`
- `cemanager.resources` --> `coderd.resources`
- `devurls.host` --> `coderd.devurlsHost`
- `ingress.loadBalancerIP` --> `coderd.serviceSpec.loadBalancerIP`
- `ingress.loadBalancerSourceRanges` -->
  `coderd.serviceSpec.loadBalancerSourceRanges`
- `ingress.service.externalTrafficPolicy` -->
  `coderd.serviceSpec.externalTrafficPolicy`
- `ingress.tls.hostSecretName` --> `coderd.tls.hostSecretName`
- `ingress.tls.devurlsHostSecretName` --> `coderd.tls.devurlsHostSecretName`
- `storageClassName` --> `postgres.default.storageClassName`
- `timescale.image` --> `postgres.default.image`
- `timescale.resources` --> `postgres.default.resources`
- `timescale.resources.requests.storage` -->
  `postgres.default.resources.requests.storage`
- `postgres.useDefault` --> `postgres.default.enable`
- `deploymentAnnotations` --> `services.annotations`
- `serviceTolerations` --> `services.tolerations`
- `clusterDomainSuffix` --> `services.clusterDomainSuffix`
- `serviceType` --> `services.type`
- `serviceAccount.annotations` -->
  `coderd.builtinProviderServiceAccount.annotations`
- `serviceAccount.labels` --> `coderd.builtinProviderServiceAccount.labels`

<!-- Turn off linting to avoid changing the link -->
<!-- markdownlint-disable MD044 -->

[updated schema]:
  https://github.com/coder/enterprise-helm/blob/1.27.0/values.yaml

<!-- markdownlint-enable MD044 -->

> The Helm charts shipped with versions 1.21 through 1.26 are
> backward-compatible, while charts shipping with v1.27 and later are not.
