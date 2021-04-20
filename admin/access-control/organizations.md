---
title: Organizations
description: Learn how to manage organizations within Coder.
---

Organizations are groups that tie together users, workspaces, and images. All of
your images and workspaces must be assigned to a specific organization. An
end-user can only access images that are assigned to the same organization they
are.

## The default organization

When you first set up Coder, you'll generate the default organization. You can
then assign users and their workspaces to that organization.

There must always be a default organization, but you can change the one set as
the default once you have two or more organizations.

## Organization roles

Like [User roles](user-roles.md), members of an organization can be assigned
different roles. There are two roles available:

<table>
    <thead>
        <tr>
            <td><b>Role</b></td>
            <td><b>Description</b></td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><b>Organization manager</b></td>
            <td>Grants full administrative access to the organization and the
            ability to manage its <b>images</b> and
            <b>members</b>. Can view, modify, and delete <b>workspaces</b>
            belonging to members of the organization.</td>
        </tr>
        <tr>
            <td><b>Organization member</b></td>
            <td>Grants basic organization access. Can use and view <b>images</b>
            belonging to the organization. Can create new
            <b>images</b> assigned to the organization. Can only access
            <b>workspaces</b> within their organization.</td>
        </tr>
    </tbody>
</table>

Please note that roles are defined per organization. Therefore, assigning
someone as an organization manager does not change their role in another
organization.

### Organization admin permissions

<table>
    <thead>
        <tr>
            <th></th>
            <th>Create</th>
            <th>Read (all)</th>
            <th>Read (own)</th>
            <th>List</th>
            <th>Delete (all)</th>
            <th>Delete (own)</th>
            <th>Update (all)</th>
            <th>Update (own)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Dev URLs</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Workspaces</td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
        </tr>
        <tr>
            <td>Images</td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
        </tr>
        <tr>
            <td>Image tags</td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
        </tr>
        <tr>
            <td>Metrics</td>
            <td></td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Org members</td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
        </tr>
        <tr>
            <td>Orgs</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Registries</td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
        </tr>
        <tr>
            <td>System banners</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Users</td>
            <td></td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
    </tbody>
</table>

### Organization member permissions

<table>
    <thead>
        <tr>
            <th></th>
            <th>Create</th>
            <th>Read (all)</th>
            <th>Read (own)</th>
            <th>List</th>
            <th>Delete (all)</th>
            <th>Delete (own)</th>
            <th>Update (all)</th>
            <th>Update (own)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Dev URLs</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Workspaces</td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
        </tr>
        <tr>
            <td>Images</td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Image tags</td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Metrics</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Org members</td>
            <td></td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Orgs</td>
            <td></td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Registries</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>System banners</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Users</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
    </tbody>
</table>

## Namespaces

> **Deprecation notice**: The `namespaceWhitelist` field has been deprecated in
> [Coder version 1.17](../../changelog/1.17.0.md).

Coder's Helm chart previously included a `namespaceWhitelist` field that
accepted a list of cluster namespaces and made them available to Coder. The
[workspace provider feature](../workspace-providers/index.md) supersedes this
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
[deploying a new workspace provider](../workspace-providers/deployment.md) to
each additional namespace in the cluster. The workspace provider provisions
workspaces to the namespace it has been deployed to, and you can control access
to each workspace provider via an organization allowlist to replace the previous
organization namespace behaviors.
