---
title: Organizations
description: Learn how to manage organizations within Coder.
---

Organizations are groups that tie together users, environments, and images. All
of your images and environments must be assigned to a specific organization. An
end-user can only access images that are assigned to the same organization they
are.

## The Default Organization

When you first set up Coder, you'll generate the default organization. You can
then assign users and their environments to that organization.

There must always be a default organization, but you can change the one set as
the default once you have two or more organizations.

## Organization Roles

Like [User Roles](user-roles.md), members of an organization can be assigned
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
            <td><b>Organization Manager</b></td>
            <td>Grants full administrative access to the organization and the
            ability to manage its <b>images</b> and
            <b>members</b>. Can view, modify, and delete <b>environments</b>
            belonging to members of the organization.</td>
        </tr>
        <tr>
            <td><b>Organization Member</b></td>
            <td>Grants basic organization access. Can use and view <b>images</b>
            belonging to the organization. Can create new
            <b>images</b> assigned to the organization. Can only access
            <b>environments</b> within their organization.</td>
        </tr>
    </tbody>
</table>

Please note that roles are defined per organization. Therefore, assigning
someone as an Organization Manager does not change their role in another
organization.

### Organization Admin Permissions

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
            <td>Environments</td>
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
            <td>Image Tags</td>
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
            <td>Org Members</td>
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
            <td>System Banners</td>
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

### Organization Member Permissions

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
            <td>Environments</td>
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
            <td>Image Tags</td>
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
            <td>Org Members</td>
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
            <td>System Banners</td>
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

> **Notice**: The `namespaceWhitelist` field has been deprecated in Coder version
1.17.

Coder's helm chart previously included a `namespaceWhitelist` field, which took
a list of namespaces in your cluster and made them available to Coder. This
field has been removed in version 1.17 to support [Workspace
Providers](../workspace-providers/index.md).

This field is no longer used in the Coder helm chart, and you will not be able
to make any changes *unless* there are no longer any environments in the
namespaces you removed being used with Coder deployments v1.17+ (if you remove
namespaces from the `namespaceWhitelist` field, the environments in the
namespaces are no longer accessible). For older Coder deployments, you can
continue using existing environments in whitelisted namespaces, though you
cannot create new environments in those namespaces.

If you want to segregate Coder environments by namespaces in a Kubernetes
cluster, you can do so by [deploying a new workspace
provider](../workspace-providers/deployment.md) to each
additional namespace in the cluster. The workspace provider provisions
environments to the namespace it has been deployed to, and you can control
access to each workspace provider via an organization allowlist to replace the
previous organization namespace behaviors.
