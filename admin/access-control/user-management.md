---
title: "User Management"
description: Learn how to add, delete and manage Coder users.
---

[Site managers](/access-control/user-roles#site-manager-permissions) can create
and manage users from the **Users** page, which is accessible under **Manage** >
**Users**.

## Creating a New User

To create a new user:

1. Go to **Manage** > **Users** > **New User**.
1. In the new dialog window, provide the user's **name** and **email address**
   and select the **Auth Type** you want for the account. Select **Built-In** as
   your Auth Type if you want the user to access Coder with a username/password
   combination; select **OpenID Connect** as your Auth Type if you would like to
   use your organization's OpenID Connect Identity Provider.
1. Finally, choose the **Organization** to which the user belongs (this will
   affect the images to which the user has access). Click **Create**.

Coder will create the new user. If you opted for the **Built-In** auth type,
Coder will display a Temporary Password. Provide this password to the user,
which they can use with their email to access their new account. For increased
security, the new user will be prompted to change their password immediately
after they log in.

## Deleting a User

To delete a user:

1. Go to **Manage** > **Users**. Find the user you want to delete and click the
   **Vertical Elipses** associated with that user.
1. Click **Delete**.
1. You'll be prompted to confirm this action. Click **Delete** to proceed.

If you're using your organization's OpenID Connect Identity Provider to manage
users, this process revokes the user's access to Coder; it does _not_ delete the
user from your identity store.
