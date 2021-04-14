---
title: "Workspaces as code"
description: "Learn how to describe environment configuration as code."
state: beta
---

Workspaces as code (WAC) brings the _infrastructure as code_ paradigm to Coder
environments. WAC allows you to define and create new environments using
**workspace templates**.

[Workspace templates](./templates.md) are declarative YAML files that describe
how to configure environments and their supporting infrastructure.

## Requirements

- You must configure a [GitHub or GitLab OAuth service](../../admin/git.md)
- The image you use in your template **must** have been
  [imported](../../images/importing.md) into Coder
- A `.coder/coder.yaml` file exists in your repository.

## Creating a workspace template

You can find a fully populated workspace template and descriptions of each field
in our [syntax guide](templates.md).

## Adding an embeddable button

To make it easy for your developers to use your template, you can generate an
embeddable Markdown button for use in your repo. See the
[admin guide](../../admin/templates.md) for details.
