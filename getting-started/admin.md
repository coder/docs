---
title: Administrators
description: Getting started with Coder as an administrator.
---

This article will walk you through the steps needed to set up, deploy, and
configure Coder so that your developers are ready create their workspaces and
begin working on their projects.

## Set up and deploy Coder

To get started with Coder, you will need to:

1. [Create a Kubernetes cluster](./setup/kubernetes/index.md)

1. [Install Coder via Helm](../setup/installation.md)

Alternatively, [Coder for Docker](../setup/docker.md) allows you to deploy Coder
quickly to machines where you have Docker installed. We recommend this option
for teams with 5-10 developers.

## Configure Coder

Once you've deployed Coder, you'll need to log in and:

1. [Upload your license file](../setup/configuration.md) (you can get a trial
   license for free [here](https://coder.com/trial))

1. Access the [administration management](../admin/index.md) menu to set up
   things such as:

   - [Access controls](../admin/access-control/index.md) with OpenID Connect
     (OIDC)
   - [Create organizations](../admin/organizations/index.md)
   - Create an OAuth app for your users to
     [connect to your Git provider](../admin/git.md)

   At a minimum, you’ll want to ensure that you:

   - [Add a container registry](../admin/registries/index.md) for your
     development environments to pull from
   - [Import an image](../images/importing.md) with the tools your developers
     need.

   You can [create custom images](../images/writing.md) for your developer
   workspaces as well.

## Provision users

To allow developers to access your Coder deployment, you can manually create and
invite users, or you can set up OpenID Connect (OIDC):

- [Azure AD](../guides/admin/oidc-azuread.md)
- [Okta](../guides/admin/oidc-okta.md)

If you are using another Identity Provider (IdP), the process should be very
similar.

With OIDC configured, Coder will automatically create a user and add them to the
[default organization](../admin/organizations/index.md) when a developer logs in
for the first time.

## Automate

You can use the Coder [command-line (CLI) tool](../cli/index.md) to interact
with Coder, as well as the [public API](../guides/api.md) to automate various
tasks through code.

## Maintain and upgrade

Coder releases [upgrades](../setup/upgrade/index.md) on the third Wednesday of
each month, with patch releases published and available as needed.

Coder maintains a public [changelog](../changelog/index.md) and
[release calendar](https://coder.com/release-calendar.ical) to keep you updated
on features, bug fixes, security updates, and breaking changes that are coming.

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

Finally, we encourage you to look through the various
[Guides](../guides/index.md) in our public documentation, as it contains more
detailed information on specific
