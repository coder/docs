---
title: "Getting Started"
description: Get Started with Coder.
---

We’re excited for you to be part of the growing community of Coder users,
and wanted to provide an onboarding guide to ensure you have a great
experience. Coder’s documentation is completely [open-source](https://github.com/cdr/docs),
so please feel free to contribute and provide feedback as you desire.

## Setup and Deploy Coder

To get started with Coder, you’ll need to [deploy Coder](./setup/index.md) into a
[Kubernetes cluster](./setup/kubernetes/index.md). We have documentation to assist you
with [creating a cluster](./setup/kubernetes/index.md) if needed as well. Once you
have a cluster, you can [install Coder via Helm](./setup/installation.md).

## Configuring Coder

When you first deploy Coder, you’ll need to [upload your license file](./setup/configuration.md)
to begin configuring the application. Once logged in, you’ll be able to access the
[administration management](.//admin/index.md) menu to set up things such as
[access controls](](.//admin/access-control/index.md) with OpenID Connect (OIDC),
[create organizations](./admin/organizations.md), and create an OAuth app for your users to
[connect to your git provider](./admin/git.md).

At a minimum, you’ll want to ensure you [add a container registry](./admin/registries/index.md)
for your development environments to pull from, and then [import an image](./images/importing.md)
with the tools your developers need. You can [create custom images](./guides/customization/custom-workspace.md)
for your developer workspaces as well.

## Provisioning Users

With some base configuration done, you’ll want to allow your developers to begin using Coder.
[Within our Admin Guides](./guides/admin/index.md), we have steps to set up OpenID Connect (OIDC) with
[Azure AD](./guides/admin/oidc-azuread.md) and [Okta](./guides/admin/oidc-okta.md). If you are using
another Identity Provider (IdP), the process should be very similar. By configuring OIDC, when your
developers log in for the first time, their user will be created and added to the
[default organization](./admin/organizations.md).

## Automation

Coder has a [Command Line (CLI) tool](./cli/index.md) to interact with Coder that you and your developers
may be interested in. The CLI is completely [open-sourced](https://github.com/cdr/coder-cli),
and contributions are always welcome. Additionally, Coder has a [public API](./guides/api.md) to automate
various tasks through code.

## Connecting Local IDEs

While Coder does support a variety of IDEs in the browser, such as VSCode and the JetBrains product suite,
some developers may desire to use their local installation of these or other IDEs with Coder.
Leveraging the [Coder CLI](./cli/index.md), developers will be able to [connect their terminal](./cli/remote-terminal.md)
to the remote environment’s terminal, and enable [file sync](./cli/file-sync.md) to have your local
directory’s tree sync with the remote file system.

## Maintenance and Updating

Coder maintains a public [changelog](./changelog/index.md) and [release calendar](https://coder.com/release-calendar.ical)
to help you stay in the know on new features, bug fixes, security updates, and breaking changes that may be
coming. Coder releases are available on the third Wednesday of each month, and patch releases are
published and available as needed.

## Interacting with Support

Coder’s standard support is included with your license. You can reach us at `support@coder.com`, and one
of our engineers will be able to assist Please include any relevant logs, error messages, and/or screenshots. Coder also
has a [public community Slack](https://cdr.co/join-community) you can join if you’d like. Finally, Coder does offer premium
support through Coder Escalation Services, which provides a faster response Service-Level Agreement (SLA).
Speak to your account executive if you’re interested in this option.

## Additional Information

There are a variety of ways to follow Coder to stay up to date on company updates, whitepapers, blog posts, and more.

- [Coder Blog](https://coder.com/blog)
- [Videos about Coder](https://coder.com/resources/videos)
- [Whitepapers](https://coder.com/resources/whitepapers)
- Social media accounts such as [LinkedIn](https://www.linkedin.com/company/coderhq),
[YouTube](https://www.youtube.com/channel/UCWexK_ECcUU3vEIdb-VYkfw), [Twitter](https://twitter.com/coderhq), and others

Finally, we encourage you to look through the various [Guides](./guides/index.md) in our public documentation,
as it contains more detailed information on specific use cases and topics.
