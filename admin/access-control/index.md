# Access control

The **Authentication** tab allows you to choose how your users log in and gain
access to Coder. Currently, you can choose between **Built-In Authentication**
and **OpenID Connect**.

## Built-in authentication

Built-in authentication, which is the default method, allows you (or any admin)
to manually create users who log in with their email address and temporary
password. Coder will ask them to change their password after they log in the
first time.

The default user session expiry time is one week for users logging in via
built-in authentication. This is non-configurable.

## OIDC authentication

The OpenID Connect (OIDC) authentication option allows you to defer identity
management to the OIDC provider of your choice (e.g., Google).

The default user session expiry time for OIDC logins is determined by the
upstream identity provider.

## Managing authentication to Coder

To manage the ways that users can login to Coder, see
[Managing authentication](manage.md)

## See also

- [User management in Coder](users/index.md)
- [User password reset](users/password-reset.md)
