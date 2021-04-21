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

## Creating a workspace from a template

When creating a new workspace from the "New Workspace" button, select "Create from Template".

![create from template](../../assets/create-from-template.png)

The form you will be brought to.

![wac user form](../../assets/wac-user-form.png)

1. Enter a friendly name for your workspace.
2. Enter the git repository that contains the `coder.yaml` configuration file. See [Workspace templates](templates.md) to learn more about these files.
3. Choose which branch on the git repo to track.
4. By default, the configuration file will be at `.coder/coder.yaml` in the project. Alternatively choose a different yaml file.
