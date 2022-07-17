---
title: Templates
description: Learn how to manage your workspace templates.
---

The **Templates** tab features options that control the behavior of
[workspace templates](../workspaces/workspace-templates/index.md).

## Enabling workspace templates

By default, workspace templates is an opt-in feature. The **Enable using
Workspace Templates** toggle allows you to enable or disable the creation of
[workspaces](../workspaces/index.md) using predefined templates located in Git
repositories.

To enable workspace templates, go to **Admin > Templates** and set **Enable
using Workspace Templates** to **On**.

![Toggle workspace templates](../assets/admin/wac_toggle.png)

## Template policy

> Template policies are currently an **alpha** feature.

If you enable the use of workspace templates, a **template policy** allows you
to control which fields users can set and which values they can use when
defining their workspaces.

Users can apply the following policies to fields:

- `read` - **Default.** Workspaces cannot modify the field
- `write` - Workspaces can overwrite the field
- `append` - Workspaces can append lists (e.g., configure.start steps) or
  mappings to the field

The default template policy is as follows:

```yaml
version: "0.2"
workspace:
  configure:
    start:
      policy: write
  dev-urls:
    policy: write
  specs:
    kubernetes:
      container-based-vm:
        policy: write
      cpu:
        policy: write
      disk:
        policy: write
      env:
        policy: write
      gpu-count:
        policy: write
      image:
        policy: write
      labels:
        policy: read
      memory:
        policy: write
      node-selector:
        policy: read
      tolerations:
        policy: read
```

Underneath the policy template preview, you can either upload your policy or
drag-and-drop the file onto the UI. Click **Save** to persist your changes.

If, at any time, you want to remove your policy and use Coder's default policy,
click **Reset to default**.

The template policy applies to all workspaces, including custom workspaces,
created and managed in Coder. If a workspace's properties conflict with the
template policy, Coder will ignore the workspace's values in favor of those
defined by the template policy.

## Embeddable Button

The **Embeddable Button** section features a form you can use for generating an
embeddable button. This button makes it easy for developers to use your
[workspace template](../workspaces/workspace-templates/index.md).

> Due to changes made to Coder v1.30.0+ to support the use of multiple Git
> providers, you must regenerate any embeddable buttons created using v1.29.x or
> earlier. Otherwise, the buttons will not work correctly.

To create your button:

1. Go to **Manage** > **Admin** > **Templates**.
1. Fill out the fields.

Once you've filled out the form, Coder generates a custom Markdown snippet,
which you can then add to your repository's `README.md`.

![Open In Coder Button](../assets/admin/wac-badge.png)
