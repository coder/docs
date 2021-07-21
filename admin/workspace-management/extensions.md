---
title: "Extensions"
description: Learn how to configure the code-server extension marketplace.
---

You can customize VS Code with extensions, which allow you to add new features
and functionality (e.g., languages, debuggers, tools), themes, and more.

## The extension marketplace

You can find the extensions available to you in the extension marketplace. Coder
enables access to the marketplace by default and requires no unique
configuration on your part. You can, however, choose between two types of
extensions marketplaces by going to **Manage** > **Admin** > **Infrastructure**,
then scrolling down to **Extensions**:

- **Public**: a Coder-hosted marketplace of open-source VS Code extensions
- **Custom**: your organization's custom VS Code extension marketplace API,
  accessed via the URL you provide

![Configuring extensions marketplace](../../assets/admin/configure-extensions.png)

## Open VSX public extension marketplace

To use [open-vsx.org](https://open-vsx.org) extensions in your Coder
environment:

1. Set the **Extension Marketplace Type** to **Custom**
1. Set the **Extension Marketplace API URL** to
   `https://open-vsx.org/vscode/gallery` (this value comes from the `serviceUrl`
   path described in
   [open-vsx's documentation](https://github.com/eclipse/openvsx/wiki/Using-Open-VSX-in-VS-Code)).

## Air-gapped marketplaces

If you run Coder in an air-gapped workspace, the public VS Code marketplace is
inaccessible to end-users. Using the **Custom** configuration option, you can
point Coder to an air-gapped instance of
[OpenVSX](https://github.com/eclipse/openvsx) to serve assets to users.

View the [OpenVSX deployment wiki] for more information.

[openvsx deployment wiki]:
  https://github.com/eclipse/openvsx/wiki/Deploying-Open-VSX
