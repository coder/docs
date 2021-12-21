---
title: "Getting started"
description: Get started with Coder.
icon:
  '<svg xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" viewBox="0 0 16 16"
  width="16" xml:space="preserve"><path d="M1 2a1 1 0 0 1 1-1h11a1 1 0 0 1 1
  1v1h.5A1.5 1.5 0 0 1 16 4.5v7a1.5 1.5 0 0 1-1.5 1.5h-.55a2.5 2.5 0 0 1-2.45
  2h-8A2.5 2.5 0 0 1 1 12.5V2zm13 10h.5a.5.5 0 0 0 .5-.5v-7a.5.5 0 0
  0-.5-.5H14v8z"/></svg>'
---

We’re excited for you to be part of the growing community of Coder users, and we
wanted to provide an onboarding guide to ensure you have a great experience.
Coder’s [documentation is publicly editable](https://github.com/cdr/docs), so
please feel free to contribute and provide feedback as you desire.

If you're participating in our hosted beta, please see our
[guide on getting started](guides/hosted-beta/index.md). If you're deploying
Coder to your own clusters, please proceed with this article.

## Set up and deploy Coder

To get started with Coder, you’ll need to [deploy Coder](./setup/index.md) to a
Kubernetes cluster. We have documentation to help you
[create a cluster](./setup/kubernetes/index.md) if needed. Once you have a
cluster, you can [install Coder via Helm](./setup/installation.md).

## Configure Coder

After you deploy Coder, you’ll need to
[upload your license file](./setup/configuration.md) before you can configure
the application (you can get a trial license for free
[here](https://coder.com/trial)). Once logged in, you’ll be able to access the
[administration management](./admin/index.md) menu to set up things such as
[access controls](./admin/access-control/index.md) with OpenID Connect (OIDC),
[create organizations](./admin/organizations/index.md), and create an OAuth app
for your users to [connect to your Git provider](./admin/git.md).

At a minimum, you’ll want to ensure you
[add a container registry](./admin/registries/index.md) for your development
environments to pull from, and [import an image](./images/importing.md) with the
tools your developers need. You can [create custom images](./images/writing.md)
for your developer workspaces as well.

## Provision users

With some base configuration done, you’ll want to allow your developers to begin
using Coder. You can manually create and invite users, or you can set up OpenID
Connect (OIDC) with [Azure AD](./guides/admin/oidc-azuread.md) or
[Okta](./guides/admin/oidc-okta.md). If you are using another Identity Provider
(IdP), the process should be very similar. With OIDC configured, Coder will
automatically create a user and add them to the
[default organization](./admin/organizations/index.md) when a developer logs in
for the first time.

## Automate

Coder has a [command-line (CLI) tool](./cli/index.md) that you and your
developers may be interested in using to interact with Coder. The CLI is
completely [open-sourced](https://github.com/cdr/coder-cli), and we always
welcome contributions. Additionally, Coder has a [public API](./guides/api.md)
that you can use to automate various tasks through code.

## Connect local IDEs

While Coder supports a
[variety of IDEs in the browser](https://coder.com/docs/coder/v1.20/workspaces/editors),
such as VSCode and the JetBrains product suite, some developers may want to use
their local installation of these tools or other IDEs with Coder. By leveraging
the [Coder CLI](./cli/index.md), developers will be able to
[connect their terminal](./cli/remote-terminal.md) to the remote environment’s
terminal, and enable [file sync](./cli/file-sync.md) to have their local
directory’s tree sync with the remote file system.

## Maintain and update

Coder maintains a public [changelog](./changelog/index.md) and
[release calendar](https://coder.com/release-calendar.ical) to help you stay in
the know on features, bug fixes, security updates, and breaking changes that are
coming. Coder releases are available on the third Wednesday of each month, and
patch releases are published and available as needed.

## Interact with Support

Coder’s standard support is included with your license. You can reach us at
[support@coder.com](mailto:support@coder.com), and one of our engineers will be
able to assist. Please include any relevant logs, error messages, or
screenshots.

Coder also has a [public community Slack](https://cdr.co/join-community) you can
join if you’d like.

Finally, Coder offers premium support through Coder Escalation Services, which
provides a faster response Service-Level Agreement (SLA). Speak to your account
executive if you’re interested in this option.

## Additional information

There are a variety of ways to follow Coder to stay up-to-date on company
updates, whitepapers, blog posts, and more.

- [Coder Blog](https://coder.com/blog)
- [Videos about Coder](https://coder.com/resources/videos)
- [Whitepapers](https://coder.com/resources/whitepapers)
- Social media accounts such as
  [LinkedIn](https://www.linkedin.com/company/coderhq),
  [YouTube](https://www.youtube.com/channel/UCWexK_ECcUU3vEIdb-VYkfw),
  [Twitter](https://twitter.com/coderhq), and others

Finally, we encourage you to look through the various
[Guides](./guides/index.md) in our public documentation, as it contains more
detailed information on specific use cases and topics.
