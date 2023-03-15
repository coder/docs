# Moving to Coder v2

Coder v2 is Coder's open core remote development platform first launched in
June 2022. Coder v2 has an [open-source](https://github.com/coder/coder) "OSS"
and an
[Enterprise paid edition](https://coder.com/docs/coder-oss/latest/enterprise).
This document shares best practices for moving your workflows from Coder v1 to
Coder v2.

![Coder v2
Dashboard](../assets/guides/coder-v2-dashboard.png)

> If you are current a Coder v1 customer and would like to try Coder v2, contact
> your account executive or [contact us](https://coder.com/contact).

## High-level concepts

Coder v2 introduces a number of new paradigms. We recommend reading the
comparison table before you proceed.

|                        | Coder v1                                                                                                                                    | Coder v2                                                                                                                             |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| **Workspace**          | Each user creates and develops on remote workspaces                                                                                         | Same as Coder v1                                                                                                                     |
| **Supported IDEs**     | Web IDEs (code-server, Jupyter) + SSH-powered desktop IDEs (e.g. VS Code, JetBrains)                                                        | Same as Coder v1                                                                                                                     |
| **Provisioner**        | Provisions workspaces on Kubernetes with hardcoded spec (pod + home volume)                                                                 | Provisions workspaces via [Terraform](https://terraform.io). Supports any resource (e.g. VM, Kubernetes, Docker)                     |
| **Template**           | Optional YAML [configuration syntax](https://coder.com/docs/coder/latest/admin/templates) for workspaces. Managed by Coder admins or git/CI | [Terraform code](https://coder.com/docs/coder-oss/latest/templates) that defines workspace specs. Managed by Coder admins or git/CI  |
| **Image**              | Container image for workspace, contains dev tools and dependencies                                                                          | Container and VM image included in [the template](https://coder.com/docs/coder-oss/latest/templates) with dev tools and dependencies |
| **Workspace options**  | CPU, RAM, GPU, disk size, image name, CVM (on/off), dotfiles                                                                                | Defined as variables in [the template](https://coder.com/docs/coder-oss/latest/templates)                                            |
| **Deployment methods** | Kubernetes, Docker                                                                                                                          | Kubernetes, Docker, VM, or bare metal                                                                                                |
| **Architecture**       | Control plane + PostgreSQL database + workspaces                                                                                            | Same as Coder v1                                                                                                                     |

<small>Keep reading for an in-depth feature comparison. Also see the
[Coder v2 documentation](https://coder.com/docs/coder-oss/)</small>

## Migration Strategy

A separate control plane is necessary to run Coder v2. A direct upgrade via Helm
is not possible since Coder v2 redefines some concepts (e.g. templates,
provisioners) and other features are still being developed (e.g. audit log,
organization support).

Short term, we recommend keeping your Coder v1 control plane and inviting a
pilot group to your Coder v2 control plane to reproduce their workflows and try
new features (e.g. Windows support, dynamic secrets, faster builds).

### Feature list key

Each of the following features have open issues on coder/coder - if they're a
priority for your team, please chime in on the GitHub issue.

✅ = Complete

⌛ = WIP/planned
[on a roadmap](https://github.com/coder/coder/discussions/categories/roadmap)

🤔 = Still considering

❌ = No current plans for feature

### Infrastructure

For small "proof-of-concept" deployments, you can use Coder's
[built-in database and tunnel](https://github.com/coder/coder#getting-started)
on a VM to avoid setting up a database, reverse proxy, and TLS.

For production use, we recommend running Coder with an external PostgresSQL
database and a reverse proxy for TLS.

- [Installing Coder v2](https://coder.com/docs/coder-oss/latest/install)

|                                        | Coder v1                                                                                                             | Coder v2                                                                                                                       |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Kubernetes                             | ✅ Helm chart                                                                                                        | ✅                                                                                                                             |
| Kubernetes (HA/multiple replicas)      | ✅                                                                                                                   | ✅                                                                                                                             |
| Docker control plane                   | ✅                                                                                                                   | ✅                                                                                                                             |
| VM control plane                       | ❌                                                                                                                   | ✅                                                                                                                             |
| Built-in PostgreSQL                    | ✅                                                                                                                   | ✅                                                                                                                             |
| External PostgreSQL support            | ✅                                                                                                                   | ✅                                                                                                                             |
| External TLS documentation             | ✅                                                                                                                   | ⌛ [#3518](https://github.com/coder/coder/issues/3518)                                                                         |
| **Multi region/cloud (control plane)** | ✅ Multi-region [satellites](https://coder.com/docs/coder/latest/admin/satellites) for faster IDE connections.       | ⌛ [#3227](https://github.com/coder/coder/issues/3227)                                                                         |
| **Multi region/cloud (workspaces)**    | ✅ [Workspace providers](https://coder.com/docs/coder/latest/admin/workspace-providers) support additional clusters. | ✅ [Templates](https://coder.com/docs/coder/latest/admin/templates) can provision resources in any clouds, clusters, or region |
| **Multi region/cloud (tunnel/SSH)**    | ✅                                                                                                                   | ✅                                                                                                                             |

### CLI

Coder v2 uses a separate
[command line utility](https://coder.com/docs/coder-oss/latest/install). To use
both CLIs on the same machine, you can install the Coder v2 CLI under a
different name (e.g. `coderv2`):

```sh
curl -sL https://coder.com/install.sh | sh -s -- --method=standalone --binary-name=coderv2 > /dev/null

# Coder v1 CLI
coder workspaces list

# Coder v2 CLI
coderv2 list
```

### Users

Like Coder v1, you can
[enable SSO via OpenID Connect](https://coder.com/docs/coder-oss/latest/install/auth#step-2-configure-coder-with-the-openid-connect-credentials)
so that any user in your federation can log in. Coder v2 optionally supports
[GitHub (Enterprise)](https://coder.com/docs/coder-oss/latest/install/auth#step-1-configure-the-oauth-application-in-github)
and [username/password](https://coder.com/docs/coder-oss/latest/users)
authentication.

> If you are interested in a bulk user and/or workspace migration utility,
> [we'd like to hear from you](https://coder.com/contact).

|                   | Coder v1 | Coder v2                                                                                        |
| ----------------- | -------- | ----------------------------------------------------------------------------------------------- |
| Dotfiles          | ✅       | Per-workspace [(dotfiles docs)](https://coder.com/docs/coder-oss/latest/dotfiles)               |
| Generated SSH key | ✅       | ✅                                                                                              |
| Default shell     | ✅       | Per-workspace [(with parameters)](https://coder.com/docs/coder-oss/latest/templates#parameters) |
| Auto-start times  | ✅       | Per-workspace                                                                                   |
| Git OAuth         | ✅       | ✅                                                                                              |

User-wide settings (e.g. shell, autostart times, dotfiles URL) are not currently
supported in Coder v2 [(#3506)](https://github.com/coder/coder/issues/3506).

### Workspaces

To migrate Coder v1 workspaces, you'll need at least one template in your Coder
v2 deployment, specifically with the image(s) you support in Coder v1.

- Docs: [Adding templates](https://coder.com/docs/coder-oss/latest/templates)

We recommend manually creating a new workspace in Coder v2 and using a utility
such as `scp` or `rsync` to copy the home directory from your v1 workspace.

Inside a v1 workspace, run the following commands to:

1. Download the Coder v2 CLI
1. Create a Coder v2 workspace
1. rsync your files to the new workspace

```sh
# Download the Coder v2 CLI (alias "coderv2")
curl -sL https://coder.com/install.sh | sh -s -- --method=standalone --binary-name=coderv2 > /dev/null

# Log in to the Coder v2 deployment (e.g. coder-v2.example.com)
coderv2 login https://coder-v2.example.com

# Create a workspace
coderv2 create <workspace-name>

# Gain SSH access to v2 workspaces
coderv2 config-ssh -y

# Copy your home directory into the new Coder v2 workspace
rsync \
    --recursive \
    --itemize-changes \
    --info=progress2 \
    --links \
    --exclude='.cache/' \
    $HOME/. coder.$CODER_WORKSPACE_NAME:/home/coder/.
```

Some workspace-level features are different in Coder v2. Refer to this
comparison:

|                                                                      | Coder v1             | Coder v2                                                                                                             |
| -------------------------------------------------------------------- | -------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Kubernetes workspaces**                                            | ✅ Hardcoded spec    | ✅ Any spec via the [template](https://github.com/coder/coder/tree/main/examples/templates/kubernetes-multi-service) |
| **Docker workspaces**                                                | ✅ Hardcoded spec    | ✅ Any spec via the Terraform [template](https://coder.com/docs/coder-oss/latest/templates)                          |
| **VM workspaces**                                                    | ❌                   | ✅ Any spec via the Terraform [template](https://coder.com/docs/coder-oss/latest/templates)                          |
| **Linux workspaces**                                                 | ✅                   | ✅                                                                                                                   |
| **Windows workspaces**                                               | ✅                   | ✅                                                                                                                   |
| **macOS workspaces**                                                 | ❌                   | ✅                                                                                                                   |
| **ARM workspaces**                                                   | ❌                   | ✅                                                                                                                   |
| **Additional resources in workspace (volume mounts, API keys, etc)** | ❌                   | ✅ Any [Terraform resource](https:///registry.terraform.io)                                                          |
| **Workspace options**                                                | Limited options      | ✅ Any options via [template parameters](https://coder.com/docs/coder-oss/latest/templates#parameters)               |
| **Edit workspace**                                                   | ✅                   | ⌛ [#4311](https://github.com/coder/coder/pull/4311)                                                                 |
| **Resource provisoning rates**                                       | ✅ Organization wide | ✅ Template wide [(needs docs)](https://github.com/coder/coder/issues/3519)                                          |
| **Manage workspaces through UI and CLI**                             | ✅                   | ✅                                                                                                                   |

### Developer experience

Some developer experience features are different, or still being worked on in
Coder v2. Refer to this table:

|                                                                     | Coder v1                                                              | Coder v2                                                                                                     |
| ------------------------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Auto-start workspace (schedule)**                                 | ✅                                                                    | ✅                                                                                                           |
| **Auto-start workspace (SSH or visit app)**                         | ❌                                                                    | 🤔 [#2909](https://github.com/coder/coder/issues/2909)                                                       |
| **Code via web terminal**                                           | ✅                                                                    | ✅                                                                                                           |
| **Code via code-server (Code Web)**                                 | ✅ Hardcoded version                                                  | ✅ Any version [via the template](https://coder.com/docs/coder-oss/latest/ides/web-ides#code-server)         |
| **Code via JetBrains Projector (web)**                              | ✅ Hardcoded version                                                  | ✅ Any version [via the template](https://coder.com/docs/coder-oss/latest/ides/web-ides#jetbrains-projector) |
| **Code with local IDE via SSH (VS Code Remote, JetBrains Gateway)** | ✅ With [coder-cli](../cli) installed                                 | ✅ With [coder](https://coder.com/docs/coder-oss/latest/install) installed                                   |
| **Custom workspace applications**                                   | ✅                                                                    | ✅ Defined in [templates](https://coder.com/docs/coder-oss/latest/templates#coder-apps)                      |
| **Access ports (SSH/tunnel)**                                       | ✅                                                                    | ✅                                                                                                           |
| **Access ports (web UI)**                                           | ✅ [Dev URLs](https://coder.com/docs/coder/latest/workspaces/devurls) | ✅                                                                                                           |
| **Share ports (web UI)**                                            | ✅ [Dev URLs](https://coder.com/docs/coder/latest/workspaces/devurls) | ✅                                                                                                           |
| **Docker in workspaces (Kubernetes)**                               | ✅ [CVMs](https://coder.com/docs/coder/latest/workspaces/cvms)        | ✅                                                                                                           |
| **Manage workspaces through UI and CLI**                            | ✅                                                                    | ✅                                                                                                           |
| **Open in Coder button**                                            | ✅                                                                    | 🤔 [(needs docs)](https://github.com/coder/coder/issues/3981)                                                |

### Enterprise/management

Some enterprise features are different, or still being worked on in Coder v2.
Refer to this table:

|                                | Coder v1          | Coder v2                                                                         |
| ------------------------------ | ----------------- | -------------------------------------------------------------------------------- |
| **Auto-stop workspace**        | ✅ Activity-based | ✅ Schedule-based & ✅ Activity-based )                                          |
| **Audit logging**              | ✅                | ✅                                                                               |
| **Organizations**              | ✅                | ✅ Groups & template permissions                                                 |
| **Workspace Proccess Logging** | ✅                | ⌛ [#5314](https://github.com/coder/coder/issues/5314)                           |
| **User metrics**               | ✅                | Template-wide metrics [(needs docs)](https://github.com/coder/coder/issues/3980) |
| **Resource quotas**            | ✅                | ✅ Max workspace limit                                                           |
| **SDK**                        | ❌                | ✅ [codersdk](https://github.com/coder/coder/tree/main/codersdk)                 |
| **REST API**                   | ✅                | ✅                                                                               |

> See the [v1 sunset frequently asked questions](./v2-faq.md) for more
> information.
