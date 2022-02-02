---
title: "User management"
description: Learn how to add, delete and manage Coder users.
---

[Site managers](/access-control/user-roles#site-manager-permissions) can create
and manage users from the **Users** page, which is accessible at **Manage** >
**Users**.

## Creating a new user

To create a new user:

1. Go to **Manage** > **Users** > **New User**.
1. When prompted, provide the user's **name** and **email address** and select
   the **Auth Type** you want for the account. Select **Built-In** as your Auth
   Type if you want the user to access Coder with a username/password
   combination; select **OpenID Connect** as your Auth Type if you would like to
   use your organization's OpenID Connect Identity Provider.
1. Finally, choose the **Organization** to which the user belongs (this will
   affect the images to which the user has access). Click **Create**.

Coder will create the new user. If you opted for the **Built-In** auth type,
Coder will display a temporary password. Provide this password to the user,
which they can use with their email to access their new account. For increased
security, Coder prompts the new user to change their password immediately after
they log in.

## Changing a user's role

Coder comes with built-in [user roles](user-roles.md) that define what actions a
user can take in the deployment.

By default, all new users are assigned the **Member** role. These users can be
upgraded to **Auditor** or **Site Manager** by another user with administrative
privileges.

To change a user's role, go to **Manage** > **Users**. Find the user and use the
**Site Role** drop-down to change the assigned role.

## Deleting a user

To delete a user:

1. Go to **Manage** > **Users**. Find the user you want to delete and click the
   **vertical ellipsis** associated with that user.
1. Click **Delete**.
1. You'll be prompted to confirm this action. Click **Delete** to proceed.

If you're using your organization's OpenID Connect identity provider to manage
users, this process revokes the user's access to Coder; it does _not_ delete the
user from your identity store.
