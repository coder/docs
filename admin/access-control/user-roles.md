---
title: User Roles
description: Learn about Coder's user roles and the privileges they offer.
---

Coder allows you to assign different roles to users, and each role comes with a
distinct set of privileges regarding what the user can access and which actions
they can perform.

There are four roles available:

<table>
    <thead>
        <tr>
            <td><b>Role</b></td>
            <td><b>Description</b></td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><b>Site Admin</b></td>
            <td>Grants full access to the system.
            Note that here can only be one Site Admin
            per system</td>
        </tr>
        <tr>
            <td><b>Site Manager</b></td>
            <td>Allows access to all administrative functionality in
            addition to basic usage rights</td>
        </tr>
        <tr>
            <td><b>Auditor</b></td>
            <td>Offers auditing functionality</td>
        </tr>
        <tr>
            <td><b>Member</b></td>
            <td>Allows basic usage of Coder</td>
        </tr>
    </tbody>
</table>

### Site Admin Permissions

<table>
    <thead>
        <tr>
            <th></th>
            <th>Create</th>
            <th>Read (all)</th>
            <th>Read (own)</th>
            <th>List</th>
            <th>Update (all)</th>
            <th>Update (own)</th>
            <th>Delete (all)</th>
            <th>Delete (own)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>API keys</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
        </tr>
        <tr>
            <td>Audit Logs</td>
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
            <td>Configuration</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Dev URLs</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
        </tr>
        <tr>
            <td>Environments</td>
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
            <td>Extensions</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
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
            <td>OAuth</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
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
            <td>Organizations</td>
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
            <td>Private Secrets</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
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
            <td>Services</td>
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
            <td>Users</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td></td>
        </tr>
    </tbody>
</table>

### Site Manager Permissions

<table>
    <thead>
        <tr>
            <th></th>
            <th>Create</th>
            <th>Read (all)</th>
            <th>Read (own)</th>
            <th>List</th>
            <th>Update (all)</th>
            <th>Update (own)</th>
            <th>Delete (all)</th>
            <th>Delete (own)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>API Keys</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
        </tr>
        <tr>
            <td>Audit Logs</td>
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
            <td>Configuration</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Dev URLs</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
        </tr>
        <tr>
            <td>Environments</td>
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
            <td>Extensions</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
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
            <td>OAuth</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
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
            <td>Private Secrets</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
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
            <td>Services</td>
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
            <td>Users</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td>X</td>
            <td></td>
        </tr>
    </tbody>
</table>

### Auditor Permissions

<table>
    <thead>
        <tr>
            <th></th>
            <th>Create</th>
            <th>Read (all)</th>
            <th>Read (own)</th>
            <th>List</th>
            <th>Update (all)</th>
            <th>Update (own)</th>
            <th>Delete (all)</th>
            <th>Delete (own)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>API Keys</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
        </tr>
        <tr>
            <td>Audit Logs</td>
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
            <td>Configuration</td>
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
            <td>Dev URLs</td>
            <td>X</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
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
            <td>Private Secrets</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
        </tr>
        <tr>
            <td>Users</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
        </tr>
    </tbody>
</table>

### Member Permissions

<table>
    <thead>
        <tr>
            <th></th>
            <th>Create</th>
            <th>Read (all)</th>
            <th>Read (own)</th>
            <th>List</th>
            <th>Update (all)</th>
            <th>Update (own)</th>
            <th>Delete (all)</th>
            <th>Delete (own)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>API Keys</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
        </tr>
        <tr>
            <td>Configuration</td>
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
            <td>Dev URLs</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
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
            <td>Private Secrets</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td></td>
            <td>X</td>
        </tr>
        <tr>
            <td>Users</td>
            <td></td>
            <td></td>
            <td>X</td>
            <td>X</td>
            <td></td>
            <td>X</td>
            <td></td>
            <td></td>
        </tr>
    </tbody>
</table>

## Changing a User's Role

By default, all new users are assigned the **Member** role. These users can be
upgraded to **Auditor** or **Site Manager** by another user with administrative
privileges.

To change a user's role, go to **Manage** > **Users**. Find the user and use the
**Site Role** drop-down to change the assigned role.
