---
title: "Update considerations"
description: Learn how to update your Coder deployment.
---

The update page provides instructions on how to update your Coder deployment.
This article, however, includes information you should be aware of prior to
updating, such as architecture updates and breaking changes.

## Updating from v1.24 to v1.25

- In 1.25, dev URLs use double dashes `--` as delimiters, instead of single
  dashes `-`. This may affect bookmarks pointing to dev URLs.
- v1.25 updates the username format to allow the use of alphanumeric character
  and hyphens. The length of the username can be 1-39 characters, inclusive.
