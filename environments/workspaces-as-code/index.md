---
title: "Workspaces As Code"
description: "Learn how to describe environment configuration as code."
state: beta
---

Workspaces as Code (WAC) brings the Infrastructure As Code paradigm to Coder
environments. [Workspace Templates](./syntax.md) are declarative YAML files that
describe how to configure environments and their supporting infrastructure. To
get started, add a `.coder/coder.yaml` file to your repository.

## Requirements

- A configured [GitHub or GitLab OAuth service](../admin/git.md)
- The image used in the template **must** be already
  [imported](../../images/importing.md) on the platform.

## Open In Coder Badge

In order to make it easy for your users to take advantage of your WAC config,
file you can add an "Open in Coder" badge to your repository's `README.md`.

To generate a badge for your repository, navigate to **Manage** > **Admin** >
**Templates** and fill out the required fields. The generated markdown can be
added to your repository's `README.md`.

![Open In Coder Button](../assets/workspaces-as-code-badge.png)
![Open In Coder Button Pt. 2](../assets/workspaces-as-code-badge-preview.png)

## Creating a WAC Config File

A fully populated config file and descriptions on each field can be found in the
[syntax guide](wac-syntax.md)
