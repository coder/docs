---
title: "User Management"
description: Learn how to add and delete Coder users.
---

Administrators may create and manage users via the User Management dashboard.

Once you've logged into your Coder deployment, the User Management dashboard is
accessible under **Manage** > **Users**.

## Creating a New User

To create a new user, go to **Manage** > **Users** > **New User**.

In the new dialog window, provide the user's **name** and **email address** and
select the **Auth Type** you want for the account:

* Select **Built-In** as your Auth Type if you want the user to access Coder
  with a username/password combination
* Select **OpenID Connect** as your Auth Type if you would like to use your
  organization's OpenID Connect Identity Provider

Finally, choose the **Organization** to which the user belongs. This will affect
the images to which the user has access.

Click **Create**.

Coder will create the new user and display a Temporary Password. Provide this
password to the user, which they can use along with their email to access their
new account. For increased security, the new user will be prompted to change
their password immediately after they log in.

## Deleting a User

To delete a user, go to **Manage** > **Users**. Find the user you want to delete
and click the **Vertical Elipses** associated with that user.

Click **Delete**.

You'll be prompted to confirm this action. Click **Delete** to proceed.

If you're using your organization's OpenID Connect Identity Provider to manage
users, this process revokes the user's access to Coder, but it does not delete
the user from your identity store.
