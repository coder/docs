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

## Upgrading from v1.24 to v1.25

- In 1.25, dev URLs use double dashes `--` as delimiters, instead of single
  dashes `-`. Please update bookmarks accordingly.

- v1.25 updates the username format to allow the use of alphanumeric character
  and hyphens. The length of the username can be 1-39 characters, inclusive.
