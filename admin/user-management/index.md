---
title: "User Management"
---

Administrators may create and manage users via the User Management dashboard.

Once you've logged into your Coder deployment, the User Management dashboard is
accessible under **Manage** > **Users**.

## Creating a New User

To create a new user, go to **Manage** > **Users** > **New User**.

In the dialog window that opens, provide the new user's **name** and **email
address** and select the **Auth Type** you want for the account.

- Select **Built-In** as your Auth Type if you want the user to access Coder
  with a username/password combination
- Select **OpenID Connect** as your Auth Type if you would like to use your
  organization's OpenID Connect Identity Provider

Finally, choose the **Organizations** to which the user belongs. This affects
the images to which the user has access.

When done, click **Create**.

Coder will create the new user and display a **Temporary Password**. Provide
this password to the user, which they will use along with their email to access
their new account. The new user will be prompted to change their password
immediately after they log in for increased security.

## Deleting a User

To delete a user, go to **Manage** > **Users**. Find the user you want to
delete, and click the **Vertical Elipses** associated with that user.

Click **Delete**.

You'll be prompted to confirm this action. Click **Delete** to proceed.

If you're using your organization's OpenID Connect Identity Provider to manage
users, this process revokes the user's access to Coder, but it does *not* delete
the user from your identity store.
