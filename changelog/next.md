---
title: "next"
description: "Released on 02/20/2021"
---

### Breaking Changes ❗

- The deprecated `Services` feature is now **removed**. All resources created
  for Services are preserved for data recovery purposes (volumes,
  database tables, etc.), but are not accessible through the Coder platform.
  Please reference
  [Docker in Environments](https://coder.com/docs/environments/cvms) for
  a guide on the new workflow for running containers with your Environment.
- The built-in Internal Extension Marketplace is now **removed**. All resources
  created for this feature are preserved for data recover purposes, but are not
  accessible through the Coder platform. For air-gapped deployments, the `Custom`
  Extension Marketplace configuration enables the use of
  [Open VSX](https://github.com/eclipse/openvsx) as
  an alternative. For more details, please view our [migration guide](TODO).

### Features ✨

- Public Rest API <apidocs.coder.com>
- Resource Pools
- Support for remote port forwarding over SSH
- Environments can now be configured to automatically start at a specified time
  each day
- web: PWA icons for jetbrains and code-server have been redesigned
- web: Input sliders have been redesigned
- web: A character counter was added to the organization description field
- web: Display warning when memory provision rate is high

### Bug Fixes 🐛

- infra: Extraneous environment variables were removed from non-CVM based
  environments

### Security Updates 🔐

There are no security updates in next.
