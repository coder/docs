---
title: Password reset
description: Learn how to reset Coder user passwords.
---

To reset a user's password:

1. Go to **Manage** > **Users**.
1. Find the user whose password you want to reset and click the vertical
   ellipsis to the right.
1. Click **Reset password**. Coder will display a temporary password that you
   can provide to the user. Click **Reset Password** to proceed with the reset.

![Confirm password reset](../../assets/admin/reset-password.png)

When the user logs in using the temporary password, Coder will prompt them to
change it.

> You can only reset passwords for users using **built-in authentication**.

## Resetting the site admin password

If you need to reset the password for a site admin, you can do so using
cemanager's **reset-admin-password** command.

> You should have the
> [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) dependency
> installed from when you first set up Coder; if not, please sure to install it
> before proceeding.

To reset the password, run the following in the terminal:

```console
# get any cemanager pod
kubectl get pods | grep cemanager- | awk '{print $1}' | head -n1

# call the reset-admin-password subcommand
kubectl exec -it <cemanager pod> -- cemanager reset-admin-password

# alternatively, you can combine the two commands above into one line
kubectl exec -it $(kubectl get pods | grep cemanager- | awk '{print $1}' | head -n1) -- cemanager reset-admin-password
```

Coder will present you with a temporary password for the site admin user; the
next time the site admin logs in with this set of credentials, Coder will prompt
them to change the password.
