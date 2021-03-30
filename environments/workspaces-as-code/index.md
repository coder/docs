---
title: "Workspaces As Code"
description: "Learn how to describe environment configuration as code."
state: beta
---

Workspaces as Code (WAC) brings Infrastructure As Code to environment
configuration. Users can use this feature to manage environment config in the
same repo as their source code; simply add a `.coder/coder.yaml` to get started.

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
