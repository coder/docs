---
title: "Moving to Coder OSS Beta"
description: What you need to know about Coder OSS 
---

Coder v2 (also referred to as [Coder OSS](https://github.com/coder/coder))
is Coder's open core remote development platform first launched in June 2022.
This document shares best practices for moving your workflows from Coder v1 to
Coder v2.

![Coder v2 Dashboard](https://raw.githubusercontent.com/coder/coder/main/docs/images/hero-image.png)

> If you are current Coder v1 customer and to try Coder v2, [we'd like to hear from
> you](https://calendly.com/bpmct/30min) to help inform our roadmap and
> migration strategy.

## High-level concepts

Coder v2 introduces a number of new paradigms. We recommend reading the comparison table before you proceed.

| | Coder v1 | Coder v2 |
| - | - | - |
| **Workspace** | Each user creates and develops on remote workspaces | Same as Coder v1 |
| **Supported IDEs** | Web IDEs (code-server, Jupyter) + SSH-powered desktop IDEs (e.g. VS Code, Jetbrains) | Same as Coder v1 |
| **Provisioner** | Provisions workspaces on Kubernetes with hardcoded spec (pod + home volume) | Provisions workspaces via [Terraform](https://terraform.io). Supports any resource (e.g. Windows VM, Kubernetes pod) | 
| **Template** | Optional YAML [configuration syntax](https://coder.com/docs/coder/latest/admin/templates) for workspaces. Managed by Coder admins or git/CI | [Terraform code](https://coder.com/docs/coder-oss/latest/templates) that defines workspace specs. Managed by Coder admins or git/CI | 
| **Image** | Container image for workspace, contains dev tools and dependencies | Often included in [the template](https://coder.com/docs/coder-oss/latest/templates) |
| **Workspace options** | CPU, RAM, GPU, disk size, image name, CVM (on/off), dotfiles | Defined as variables in [the template](https://coder.com/docs/coder-oss/latest/templates) |
| **Deployment methods** | Kubernetes, Docker  | Kubernetes, Docker, VM, or bare metal |
| **Architecture** | Control plane + PostgreSQL database + workspaces | Same as Coder v1 |

<small>Keep reading for an in-depth feature comparison. Also see the [Coder v2 documentation](https://coder.com/docs/coder-oss/)</small>

## Migration Strategy

A seperate deployment is necessary to run Coder v2. A direct upgrade via Helm is not possible since Coder v2 introduces new concepts (e.g. templates, provisioners) and other features are still being developed (e.g. audit log, organization support).

Short term, we recommend keeping your Coder v1 deployment and inviting a pilot group to your Coder v2 deployment to reproduce their workflows and try new features (e.g. Windows support, dynamic secrets, faster builds). 

### Infrastructure

For small "proof-of-concept" deployments, you can use Coder's [built-in database and tunnel](https://github.com/coder/coder#getting-started) on a VM to avoid setting up a 
database, reverse proxy, and TLS.

For production use, we recommend running Coder with an external PostgresSQL database and a reverse proxy for TLS.

| | Coder v1 | Coder v2 |
| - | - | - |
| Kubernetes | ✅ Helm chart | ⌛ Helm chart [(needs docs)](https://github.com/coder/coder/issues/3224) |
| Kubernetes (HA/multiple replicas) | ✅ | ⌛ [#3502](https://github.com/coder/coder/issues/3502) |
| Kubernetes (built-in database) | ✅ | ❌ |
| Docker deployment | ✅ | ✅ |
| VM deployment | ❌ | ✅ [system packages](https://coder.com/docs/coder-oss/latest/install#system-packages) and [prebuilt binaries](https://coder.com/docs/coder-oss/latest/install#manual) |
| Built-in PostgreSQL | ✅ | ✅ |
| Built-in TLS tunnel | ❌ | ✅ |
| External PostgreSQL support | ✅ | ✅ ([configuration flag](https://coder.com/docs/coder-oss/latest/install/configure)) |
| External TLS documentation | ✅ (via [cert-manager](https://coder.com/docs/coder/latest/guides/tls-certificates)) | ⌛ [#3518](https://github.com/coder/coder/issues/3518) |
| **Multi region/cloud (workspaces)** | ✅ [Workspace providers](https://coder.com/docs/coder/latest/admin/workspace-providers) support additional clusters. | ✅ [Templates](https://coder.com/docs/coder/latest/admin/templates) can provision resources in any clouds, clusters, or region |
| **Multi region/cloud (provisioning)** | ❌ | ⌛ [#44](https://github.com/coder/coder/issues/44) |
| **Multi region/cloud (authentication)** | ✅ Authenticates to clusters via secrets stored in the database | ✅ Authenticates via Terraform provider and [provisioner](https://coder.com/docs/coder-oss/latest/architecture) environment | 
| **Multi region/cloud (dashboard)** | ✅ Multi-region [satellites](https://coder.com/docs/coder/latest/admin/satellites) for faster IDE connections. | ⌛ [#3227](https://github.com/coder/coder/issues/3227) | 
| **Multi region/cloud (tunnel/SSH)** | ✅ [Direct connections via STUN](https://coder.com/docs/coder/latest/admin/stun) | ✅ Direct connections via STUN ([configuration flag](https://coder.com/docs/coder-oss/latest/install/configure)) | 

<small>See the Coder OSS [installation docs](https://coder.com/docs/coder-oss/latest/install) for more details. Missing something or have feedback? [Let us know](https://coder.com/contact)</small>

### CLI

Coder v2 uses a seperate [command line utility](https://coder.com/docs/coder-oss/latest/install). To use both CLIs on the same machine, you can install the Coder v2 CLI under a different name (e.g. `coder2`):

```sh
curl -sL https://coder.com/install.sh | sh -s -- --method=standalone --binary-name=coder2 > /dev/null

# Coder v1 CLI
coder workspaces list

# Coder v2 CLI
coder2 list
```

### Users

Like Coder v1, you can [enable SSO via OpenID Connect](https://coder.com/docs/coder-oss/latest/install/auth#step-2-configure-coder-with-the-openid-connect-credentials) so that any user in your federation can log in. Coder v2 optionally supports [GitHub (Enterprise)](https://coder.com/docs/coder-oss/latest/install/auth#step-1-configure-the-oauth-application-in-github) and [username/password](https://coder.com/docs/coder-oss/latest/users) authentication.

> If you are interested in a bulk user and/or workspace migration utility, [we'd like to
> hear from you](https://calendly.com/bpmct/30min).


| | Coder v1 | Coder v2 |
| - | - | - |
| Avatar | ✅ | ❌ | 
| Dotfiles | ✅ | Per-workspace [(dotfiles docs)](https://coder.com/docs/coder-oss/latest/dotfiles) | 
| Generated SSH key | ✅ | ✅ | 
| Default shell | ✅ | Per-workspace [(with parameters)](https://coder.com/docs/coder-oss/latest/templates#parameters) | 
| Auto-start times | ✅ | Per-workspace | 
| Git OAuth | ✅ | SSH-key only | 

<small>Missing something or have feedback? [Let us know](https://coder.com/contact)</small>

User-wide settings (e.g. avatar, shell, autostart times, dotfiles URL) are not currently supported in Coder v2 [(#3506)](https://github.com/coder/coder/issues/3506) but this behavior can often be replicated via workspace-level parameters. See the [feature comparion](#feature-comparison) below for more details.

### Workspaces

To migrate Coder v1 workspaces, you'll need at least one [template](https://coder.com/docs/coder-oss/latest/templates)
in your Coder v2 deployment, specifically with the image(s) you support in Coder v1.

> If you are interested in a bulk user and/or workspace migration utility, [we'd like to
> hear from you](https://calendly.com/bpmct/30min).

From there, we recommend manually creating a workspace in Coder v2 and using a utility such as `scp` or `rsync` to copy the home directory from your v1 workspace.

```sh
# Inside a Coder v1 workspace terminal (e.g. coder-v1.example.com)

# Download the Coder v2 CLI (alias "coder2")
curl -sL https://coder.com/install.sh | sh -s -- --method=standalone --binary-name=coder2 > /dev/null

# Log in to the Coder v2 deployment (e.g. coder-v2.example.com)
coder2 login https://coder-v2.example.com

# Create a workspace
coder2 create <workspace-name>

# Gain SSH access to v2 workspaces
coder2 config-ssh -y

# Copy your home directory into the new Coder v2 workspace
rsync \
    --recursive \
    --itemize-changes \
    --info=progress2 \
    --links \
    --exclude='.cache/' \
    $HOME/. coder.$CODER_WORKSPACE_NAME:/home/coder/.
```

| | Coder v1 | Coder v2 |
| - | - | - |
| **Kubernetes workspaces** | ✅ Hardcoded spec | ✅ Any spec via the [template](https://github.com/coder/coder/tree/main/examples/templates/kubernetes-multi-service) | 
| **Docker workspaces** | ✅ Hardcoded spec | ✅ Any spec via the Terraform [template](https://coder.com/docs/coder-oss/latest/templates) | 
| **VM workspaces** | [EC2 containers only](https://coder.com/docs/coder/latest/admin/workspace-providers/deployment/ec2#prerequisites) | ✅ Any spec via the Terraform [template](https://coder.com/docs/coder-oss/latest/templates) | 
| **Linux workspaces** | ✅ | ✅ | 
| **Windows workspaces** | ✅ | ✅ | 
| **macOS workspaces** | ❌ | ✅ | 
| **ARM workspaces** | ❌ | ✅ | 
| **Additional resources in workspace (volume mounts, API keys, etc)** | ❌ | ✅ Any [Terraform resource](https:///registry.terraform.io) | 
| **Workspace options** | ✅ Hardcoded options | ✅ Any options via [template parameters](https://coder.com/docs/coder-oss/latest/templates#parameters) |
| **Edit workspace** | ✅ | ⌛ [#802](https://github.com/coder/coder/issues/802) |
| **Resource provisoning rates** | ✅ Organization wide | ✅ Template wide [(needs docs)](https://github.com/coder/coder/issues/3519) |
| **Delete workspace** | ✅ | ✅ |

### Other features

| | Coder v1 | Coder v2 |
| - | - | - |
| **Organizations** | ✅ | ❌ |
