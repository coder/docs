---
title: Organizations
description: Learn about Coder organizations.
---

Organizations are groups that tie together users, workspaces, and images. You
must assign all of your images and workspaces to a specific organization. An
end-user can only access images that are assigned to the same organization they
are.

> Be sure to familiarize yourself with the
> [types of roles](access-control/organizations.md) you can assign users within
> an organization.

## The default organization

Coder automatically creates a default organization for you during the deployment
process. You can then assign users and their workspaces to that organization.

If you have multiple organizations, you can set one or more as the default; you
can also change which organizations are defaults at any time.

## Namespaces

> **Deprecation notice**: The `namespaceWhitelist` field has been deprecated in
> [Coder version 1.17](../changelog/1.17.0.md).

Coder's Helm chart previously included a `namespaceWhitelist` field that
accepted a list of cluster namespaces and made them available to Coder. The
[workspace provider feature](workspace-providers/index.md) supersedes this
field.

You will not be able to make any changes _unless_ you are removing namespaces
that no longer contain workspaces with Coder deployments v1.17.0 or later (if
you remove namespaces from the `namespaceWhitelist` field, the workspaces in the
namespaces are no longer accessible).

For older Coder deployments, you can continue using existing workspaces in
whitelisted namespaces, though you cannot create new workspaces in those
namespaces.

If you want to separate Coder workspaces by namespaces in a Kubernetes cluster,
you can do so by
[deploying a new workspace provider](workspace-providers/deployment.md) to each
additional namespace in the cluster. The workspace provider provisions
workspaces to the namespace it has been deployed to, and you can control access
to each workspace provider via an organization allowlist to replace the previous
organization namespace behaviors.
