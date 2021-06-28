---
title: Browser security
description: Learn about Coder's browser security options.
---

Coder offers two browser security features that you can choose to enable. These
are available under **Manage** > **Admin** > **Infrastructure**.

## HTTP Strict Transport Security

If you are serving Coder over HTTPS, we recommend enabling the
**Strict-Transport-Security Header** option, which adds the [HTTP Strict
Transport Security] header to responses. This browser feature requires future
requests to occur over HTTPS.

[http strict transport security]:
  https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security

![Toggle HTTP Strict Transport Security Header](../assets/admin/http-strict-transport-security-header.png)

## Secure Cookie

The **Secure Cookie** option controls the [`secure` property of cookies] that
Coder issues. This prevents browsers from sending sensitive cookies, such as
those containing credentials, over unencrypted (HTTP) connections. We recommend
enabling this setting if you are serving Coder over HTTPS.

[`secure` property of cookies]:
  https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies

![Toggle Secure Cookie](../assets/admin/secure-cookie.png)
