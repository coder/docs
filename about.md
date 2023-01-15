# About

Coder is a self-hosted platform that allows organizations to securely provision
developer workspaces for DevOps, infrastructure, and software engineering teams.

Coder's pre-configured workspaces allow project organization members to define
what language version and tooling are required to provide consistency across the
organization and enable new members to onboard and contribute. Developers focus
on their projects and the end product, not on setup.

These pre-configured workspaces are the foundation of Coder's _Dev Workspaces as
Code_ paradigm, allowing a project's language and tooling dependencies to be
source controlled along with the code itself.

With Coder, engineers can continue using the development tools, CI/CD pipelines,
source code management systems, and editors they know and love while leveraging
the power of cloud and automation.

## Our mission

Developers should spend their time writing code, not getting their development
workspace ready. Coder aims to empower organizations to harness the cloud's
power to provide consistent, secure, and performant workspaces for their
development teams.

Our software has been pulled over 19 million times from Docker, received over
45,000 stars on GitHub, and is used by some of the world's largest enterprises.
We're also working with pilot organizations to shape the future of remote
development through Coder.

## Why Coder

Coder's _dev workspaces as code_ paradigm is new for software development. Its
key benefits include:

**Automated setup and instant onboarding**: Your workspaces are created via
pre-configured images, so there's little setup time for your developers. New
developers can begin contributing right away instead of spending time setting up
their workspace.

![Onboarding](assets/onboard.png)

- **Workspace consistency**: Every component of your workspaces is predefined
  and preapproved, reducing configuration drift caused by variations in
  development workspaces. The images used to create workspaces can also be
  source-controlled the way that your code is.

- **Performant workspaces**: Coder empowers you to use servers over local
  hardware to perform resource-intensive development operations. Developers are,
  therefore, not limited to the computing power of the device on which they're
  working or the slow network uploads of large files. All processes are
  performed on the cluster, with only the commands sent over the network.

  ![Performance](assets/performance.png)

- **Zero overhead**: Coder performs all graphical rendering on the client,
  minimizing network traffic and resulting in zero overhead for most workspaces.
  This reduces things like typing lag -- Coder enables remote access with the
  performance of a local workspace.

- **Simple updates**: As soon as you push updates to your organization's base
  development image, developers receive notifications in the dashboard that
  there's an update available. Your developers can upgrade when convenient, and
  you can track which versions your developers are using, providing visibility
  into workspace consistency.

  ![Updates](assets/update.png)

- **Centralized source code**: Keeping source code centralized on company
  servers mitigates the risk of loss or theft. Developers can work on their
  projects from anywhere while using any device with an internet browser.

  ![Security](assets/firewall.png)

- **Improved security**: Development actions are centralized on your internal
  infrastructure, allowing insight into potential threats. Furthermore,
  deploying Coder into an air-gapped workspace will provide additional
  protection around your organization's intellectual property.
