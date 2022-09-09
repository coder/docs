---
title: "Moving to Coder OSS"
description: What you need to know about Coder OSS
---

[Coder OSS](https://github.com/coder/coder) is Coder's open core remote
development platform first launched in June 2022. This document shares best
practices for moving your workflows from Coder v1 to Coder OSS.

![Coder OSS
Dashboard](https://raw.githubusercontent.com/coder/coder/main/docs/images/hero-image.png)

> If you are current a Coder v1 customer and would like to try Coder OSS,
> [we'd like to hear from you](https://coder.com/contact) to help inform our
> roadmap and migration strategy.

## High-level concepts

Coder OSS introduces a number of new paradigms. We recommend reading the
comparison table before you proceed.

|                        | Coder v1                                                                                                                                    | Coder OSS                                                                                                                           |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **Workspace**          | Each user creates and develops on remote workspaces                                                                                         | Same as Coder v1                                                                                                                    |
| **Supported IDEs**     | Web IDEs (code-server, Jupyter) + SSH-powered desktop IDEs (e.g. VS Code, JetBrains)                                                        | Same as Coder v1                                                                                                                    |
| **Provisioner**        | Provisions workspaces on Kubernetes with hardcoded spec (pod + home volume)                                                                 | Provisions workspaces via [Terraform](https://terraform.io). Supports any resource (e.g. Windows VM, Kubernetes pod)                |
| **Template**           | Optional YAML [configuration syntax](https://coder.com/docs/coder/latest/admin/templates) for workspaces. Managed by Coder admins or git/CI | [Terraform code](https://coder.com/docs/coder-oss/latest/templates) that defines workspace specs. Managed by Coder admins or git/CI |
| **Image**              | Container image for workspace, contains dev tools and dependencies                                                                          | Container and VM image included in [the template](https://coder.com/docs/coder-oss/latest/templates)                                |
| **Workspace options**  | CPU, RAM, GPU, disk size, image name, CVM (on/off), dotfiles                                                                                | Defined as variables in [the template](https://coder.com/docs/coder-oss/latest/templates)                                           |
| **Deployment methods** | Kubernetes, Docker                                                                                                                          | Kubernetes, Docker, VM, or bare metal                                                                                               |
| **Architecture**       | Control plane + PostgreSQL database + workspaces                                                                                            | Same as Coder v1                                                                                                                    |

<small>Keep reading for an in-depth feature comparison. Also see the
[Coder OSS documentation](https://coder.com/docs/coder-oss/)</small>

## Migration Strategy

A seperate deployment is necessary to run Coder OSS. A direct upgrade via Helm
is not possible since Coder OSS redefines some concepts (e.g. templates,
provisioners) and other features are still being developed (e.g. audit log,
organization support).

Short term, we recommend keeping your Coder v1 deployment and inviting a pilot
group to your Coder OSS deployment to reproduce their workflows and try new
features (e.g. Windows support, dynamic secrets, faster builds).

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

- [Installing Coder OSS](https://coder.com/docs/coder-oss/latest/install)

|                                         | Coder v1                                                                                                             | Coder OSS                                                                                                                                                             |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Kubernetes                              | ✅ Helm chart                                                                                                        | ⌛ Helm chart [(needs docs)](https://github.com/coder/coder/issues/3224)                                                                                              |
| Kubernetes (HA/multiple replicas)       | ✅                                                                                                                   | ⌛ [#3502](https://github.com/coder/coder/issues/3502)                                                                                                                |
| Kubernetes (built-in database)          | ✅                                                                                                                   | ❌                                                                                                                                                                    |
| Docker deployment                       | ✅                                                                                                                   | ✅                                                                                                                                                                    |
| VM deployment                           | ❌                                                                                                                   | ✅ [system packages](https://coder.com/docs/coder-oss/latest/install#system-packages) and [prebuilt binaries](https://coder.com/docs/coder-oss/latest/install#manual) |
| Built-in PostgreSQL                     | ✅                                                                                                                   | ✅                                                                                                                                                                    |
| External PostgreSQL support             | ✅                                                                                                                   | ✅ ([configuration flag](https://coder.com/docs/coder-oss/latest/install/configure))                                                                                  |
| External TLS documentation              | ✅ (via [cert-manager](https://coder.com/docs/coder/latest/guides/tls-certificates))                                 | ⌛ [#3518](https://github.com/coder/coder/issues/3518)                                                                                                                |
| **Multi region/cloud (workspaces)**     | ✅ [Workspace providers](https://coder.com/docs/coder/latest/admin/workspace-providers) support additional clusters. | ✅ [Templates](https://coder.com/docs/coder/latest/admin/templates) can provision resources in any clouds, clusters, or region                                        |
| **Multi region/cloud (authentication)** | ✅ Authenticates to clusters via secrets stored in the database                                                      | ✅ Authenticates via Terraform provider and [provisioner](https://coder.com/docs/coder-oss/latest/architecture) environment                                           |
| **Multi region/cloud (dashboard)**      | ✅ Multi-region [satellites](https://coder.com/docs/coder/latest/admin/satellites) for faster IDE connections.       | ⌛ [#3227](https://github.com/coder/coder/issues/3227)                                                                                                                |
| **Multi region/cloud (tunnel/SSH)**     | ✅ [Direct connections via STUN](https://coder.com/docs/coder/latest/admin/stun)                                     | ✅ Direct connections via STUN ([configuration flag](https://coder.com/docs/coder-oss/latest/install/configure))                                                      |

<small>Something missing, or have feedback?
[Let us know](https://coder.com/contact)</small>

### CLI

Coder OSS uses a seperate
[command line utility](https://coder.com/docs/coder-oss/latest/install). To use
both CLIs on the same machine, you can install the Coder OSS CLI under a
different name (e.g. `codeross`):

```sh
curl -sL https://coder.com/install.sh | sh -s -- --method=standalone --binary-name=codeross > /dev/null

# Coder v1 CLI
coder workspaces list

# Coder OSS CLI
codeross list
```

### Users

Like Coder v1, you can
[enable SSO via OpenID Connect](https://coder.com/docs/coder-oss/latest/install/auth#step-2-configure-coder-with-the-openid-connect-credentials)
so that any user in your federation can log in. Coder OSS optionally supports
[GitHub (Enterprise)](https://coder.com/docs/coder-oss/latest/install/auth#step-1-configure-the-oauth-application-in-github)
and [username/password](https://coder.com/docs/coder-oss/latest/users)
authentication.

> If you are interested in a bulk user and/or workspace migration utility,
> [we'd like to hear from you](https://coder.com/contact).

|                   | Coder v1 | Coder OSS                                                                                       |
| ----------------- | -------- | ----------------------------------------------------------------------------------------------- |
| Avatar            | ✅       | ❌                                                                                              |
| Dotfiles          | ✅       | Per-workspace [(dotfiles docs)](https://coder.com/docs/coder-oss/latest/dotfiles)               |
| Generated SSH key | ✅       | ✅                                                                                              |
| Default shell     | ✅       | Per-workspace [(with parameters)](https://coder.com/docs/coder-oss/latest/templates#parameters) |
| Auto-start times  | ✅       | Per-workspace                                                                                   |
| Git OAuth         | ✅       | SSH key only                                                                                    |

<small>Something missing, or have feedback?
[Let us know](https://coder.com/contact)</small>

User-wide settings (e.g. avatar, shell, autostart times, dotfiles URL) are not
currently supported in Coder OSS
[(#3506)](https://github.com/coder/coder/issues/3506).

### Workspaces

> If you are interested in a bulk user and/or workspace migration utility,
> [we'd like to hear from you](https://coder.com/contact).

To migrate Coder v1 workspaces, you'll need at least one template in your Coder
OSS deployment, specifically with the image(s) you support in Coder v1.

- Docs: [Adding templates](https://coder.com/docs/coder-oss/latest/templates)

We recommend manually creating a new workspace in Coder OSS and using a utility
such as `scp` or `rsync` to copy the home directory from your v1 workspace.

You can run the following commands inside a Coder v1 workspace to create a Coder
OSS workspace and migrate your files:

```sh
# Download the Coder OSS CLI (alias "codeross")
curl -sL https://coder.com/install.sh | sh -s -- --method=standalone --binary-name=codeross > /dev/null

# Log in to the Coder OSS deployment (e.g. coder-v2.example.com)
codeross login https://coder-v2.example.com

# Create a workspace
codeross create <workspace-name>

# Gain SSH access to v2 workspaces
codeross config-ssh -y

# Copy your home directory into the new Coder OSS workspace
rsync \
    --recursive \
    --itemize-changes \
    --info=progress2 \
    --links \
    --exclude='.cache/' \
    $HOME/. coder.$CODER_WORKSPACE_NAME:/home/coder/.
```

Some workspace-level features are different in Coder OSS. Refer to this
comparison:

|                                                                      | Coder v1                                                                                                          | Coder OSS                                                                                                            |
| -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Kubernetes workspaces**                                            | ✅ Hardcoded spec                                                                                                 | ✅ Any spec via the [template](https://github.com/coder/coder/tree/main/examples/templates/kubernetes-multi-service) |
| **Docker workspaces**                                                | ✅ Hardcoded spec                                                                                                 | ✅ Any spec via the Terraform [template](https://coder.com/docs/coder-oss/latest/templates)                          |
| **VM workspaces**                                                    | [EC2 containers only](https://coder.com/docs/coder/latest/admin/workspace-providers/deployment/ec2#prerequisites) | ✅ Any spec via the Terraform [template](https://coder.com/docs/coder-oss/latest/templates)                          |
| **Linux workspaces**                                                 | ✅                                                                                                                | ✅                                                                                                                   |
| **Windows workspaces**                                               | ✅                                                                                                                | ✅                                                                                                                   |
| **macOS workspaces**                                                 | ❌                                                                                                                | ✅                                                                                                                   |
| **ARM workspaces**                                                   | ❌                                                                                                                | ✅                                                                                                                   |
| **Additional resources in workspace (volume mounts, API keys, etc)** | ❌                                                                                                                | ✅ Any [Terraform resource](https:///registry.terraform.io)                                                          |
| **Workspace options**                                                | ✅ Hardcoded options                                                                                              | ✅ Any options via [template parameters](https://coder.com/docs/coder-oss/latest/templates#parameters)               |
| **Edit workspace**                                                   | ✅                                                                                                                | ⌛ [#802](https://github.com/coder/coder/issues/802)                                                                 |
| **Resource provisoning rates**                                       | ✅ Organization wide                                                                                              | ✅ Template wide [(needs docs)](https://github.com/coder/coder/issues/3519)                                          |
| **Delete workspace**                                                 | ✅                                                                                                                | ✅                                                                                                                   |

<small>Something missing, or have feedback?
[Let us know](https://coder.com/contact)</small>

### Developer experience

Some developer experience features are different, or still being worked on in
Coder OSS. Refer to this table:

|                                                      | Coder v1                                                              | Coder OSS                                                                                                    |
| ---------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Auto-start workspace (schedule)**                  | ✅                                                                    | ✅                                                                                                           |
| **Auto-start workspace (SSH or visit app)**          | ❌                                                                    | 🤔 [#2909](https://github.com/coder/coder/issues/2909)                                                       |
| **Code via web terminal**                            | ✅                                                                    | ✅                                                                                                           |
| **Code via code-server (Code Web)**                  | ✅ Hardcoded version                                                  | ✅ Any version [via the template](https://coder.com/docs/coder-oss/latest/ides/web-ides#code-server)         |
| **Code via JetBrains Projector (web)**               | ✅ Hardcoded version                                                  | ✅ Any version [via the template](https://coder.com/docs/coder-oss/latest/ides/web-ides#jetbrains-projector) |
| **Code via SSH (VS Code Remote, JetBrains Gateway)** | ✅ With [coder-cli](https://github.com/coder/coder-cli) installed     | ✅ With [coder](https://coder.com/docs/coder-oss/latest/install) installed                                   |
| **Custom workspace applications**                    | ✅                                                                    | ✅ Defined in [templates](https://coder.com/docs/coder-oss/latest/templates#coder-apps)                      |
| **Access ports (SSH/tunnel)**                        | ✅                                                                    | ✅                                                                                                           |
| **Access ports (web UI)**                            | ✅ [Dev URLs](https://coder.com/docs/coder/latest/workspaces/devurls) | ⌛ [(#1624)](https://github.com/coder/coder/issues/1624)                                                     |
| **Share ports (web UI)**                             | ✅ [Dev URLs](https://coder.com/docs/coder/latest/workspaces/devurls) | ⌛ [(#3515)](https://github.com/coder/coder/issues/3515)                                                     |
| **Docker in workspaces (Kubernetes)**                | ✅ [CVMs](https://coder.com/docs/coder/latest/workspaces/cvms)        | ⌛ [(needs docs)](https://github.com/coder/coder/issues/3376)                                                |

<small>Something missing, or have feedback?
[Let us know](https://coder.com/contact)</small>

### Enterprise/management

Some enterprise features are different, or still being worked on in Coder OSS.
Refer to this table:

|                            | Coder v1          | Coder OSS                                                                                 |
| -------------------------- | ----------------- | ----------------------------------------------------------------------------------------- |
| **Auto-stop workspace**    | ✅ Activity-based | ✅ Schedule-based ⌛ Activity-based [(#2995)](https://github.com/coder/coder/issues/2995) |
| **Audit logging**          | ✅                | ⌛ [#3251](https://github.com/coder/coder/issues/3251)                                    |
| **Organizations**          | ✅                | ❌                                                                                        |
| **User metrics**           | ✅                | Some via Prometheus export [(needs docs)](https://github.com/coder/coder/issues/3520)     |
| **Resource limits/quotas** | ✅                | ⌛ [#2988](https://github.com/coder/coder/issues/2988)                                    |
| **SDK**                    | ✅                | ✅ [codersdk](https://github.com/coder/coder/tree/main/codersdk)                          |
| **REST API**               | ✅                | 🤔 [(needs docs)](https://github.com/coder/coder/issues/3522)                             |

<small>Something missing, or have feedback?
[Let us know](https://coder.com/contact)</small>
