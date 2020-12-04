---
title: "Organizations"
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

Like [User Roles](./../user-management/roles.md), members of an organization can
be assigned different roles. There are two roles available:

<table>
    <tr>
        <th>Organization Manager</th>
        <td>Grants full administrative access to the organization and the ability
        to manage its images, services, and members. Can view, modify, and delete
        environments belonging to members of the organization.</td>
    </tr>
    <tr>
        <th>Organization Member</th>
        <td>Grants basic organization access. Can use and view images and
        services belonging to the organization. Can create new images assigned
        to the organization. Can only access environments within their organization.</td>
    </tr>
</table>

Please note that roles are defined per organization. Therefore, assigning
someone as an Organization Manager does not change their role in another
organization.
