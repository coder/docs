---
title: "Workspace templates"
description: "Learn how to describe workspace configuration as code."
state: alpha
---

Workspace templates brings the _infrastructure as code_ paradigm to Coder
workspaces. Templates allow you to define and create new workspaces using YAML.

[Workspace templates](./templates.md) are declarative YAML files that describe
how to configure workspaces and their supporting infrastructure. Coder supports
files with either the `.yaml` or `.yml` extension.

## Requirements

- You must configure a [Git OAuth service of your choice](../../admin/git.md)
- The image you use in your template **must** have been
  [imported](../../images/importing.md) into Coder
- A `.coder/<template-name>.yaml` file exists in your repository.

We strongly recommend allowing the Git provider to run a webhook capable of
reaching the Coder server for immediate template updates. Otherwise, Coder will
update your workspace templates daily.

## Creating a workspace template

You can find a fully populated workspace template and descriptions of each field
in our [syntax guide](templates.md).

## Creating a workspace using a template

To create a new workspace using a template, go to **New Workspace** > **Create
from Template**.

![Create from template button](../../assets/workspaces/workspace-templates/create-from-template.png)

When prompted, provide:

- **Workspace Name**: A name for your workspace
- **Git Repository URL**: The git repository that contains your `coder.yaml`
  configuration file. See [Workspace templates](templates.md) for more
  information about these files
- **Branch**: The branch in your git repo to track
- **Path to template**: The path to your workspace template. By default, this
  will be `.coder/coder.yaml`, but if you choose a different path, provide it
  here

![Create workspace from template](../../assets/workspaces/workspace-templates/wac-user-form.png)

## Adding an embeddable button

To make it easy for your developers to use your template, you can generate an
embeddable Markdown button for use in your repo. See the
[admin guide](../../admin/templates.md) for details.

## Using templates with Coder for Docker

[Coder for Docker](../../setup/coder-for-docker/index.md) supports the use of
workspace templates. However, the configuration has
[some differences that are outlined in our setup doc](../../setup/coder-for-docker/local.md)
