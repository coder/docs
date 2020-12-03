Coder's *Dev Environments as Code* paradigm is new for software development. Its
key benefits include:

- **Automated Setup and Instant Onboarding**: Because your environments are
  created via pre-configured images, there's little setup time involved for your
  developers. New developers can begin contributing right away instead of
  spending time setting up their working environment.

![Onboarding](./../assets/onboard.png)

- **Environmental Consistency**: Every component of your environments are
  predefined and preapproved, reducing configuration drift caused by variations
  in development environments. The images used to create environments can also
  be source-controlled the way that your code is.

- **Performant Environments**: Coder empowers you to use servers over local
  hardware to perform resource-intensive development operations. Developers are,
  therefore, not limited to the compute power of the device on which they're
  working or the slow network uploads of large files. All processes are
  performed on the cluster, with only the commands sent over the network.

![Performance](./../assets/performance.png)

- **Zero Overhead**: Coder performs all graphical rendering on the client,
  minimizing network traffic and resulting in zero overhead for most
  environments. This reduces things like typing lag -- Coder enables remote
  access with the performance of a local environment.

- **Simple Updates**: As soon as you push updates to your organization's base
  development image, developers receive notifications in the dashboard that
  there's an update available. Your developers can upgrade when convenient, and
  you can track which versions your developers are using, providing visibility
  into environmental consistency.

![Updates](./../assets/update.png)

- **Centralized Source Code**: Keeping source code centralized on company
  servers mitigates the risk of loss or theft. Developers can work on their
  projects from anywhere while using any device with an internet browser.

![Security](./../assets/firewall.png)

- **Improved Security**: Development actions are centralized on your internal
  infrastructure, allowing insight into potential threats. Furthermore,
  deploying Coder into an air-gapped environment will provide additional
  security around your organization's intellectual property.
  