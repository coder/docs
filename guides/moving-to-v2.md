---
title: "Moving to Coder v2 Beta"
description: What you need to know about Coder v2 
---

Coder v2 (also referred to as [Coder OSS](https://github.com/coder/coder))
is Coder's open core remote development platform first launched in June 2022.
This document shares best practices for moving your workflows from Coder v1 to
Coder v2.

> If you are current Coder v1 customer and to try Coder v2, [we'd like to hear from
> you](https://calendly.com/bpmct/30min) to help inform our roadmap and
> migration strategy.

## Key concepts

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

<small>For an in-depth comparison of features, keep reading. Also see the [Coder v2 documentation](https://coder.com/docs/coder-oss/)</small>

## Migration

A seperate deployment is necessary to run Coder v2. A direct upgrade via Helm is not possible since Coder v2 introduces new concepts (e.g. templates, provisioners) and other features are still being developed (e.g. audit log, organization support).

Short term, we recommend keeping your Coder v1 deployment and inviting users to a Coder v2 "proof of concept" deployment that leverages new features (e.g. Windows support, dynamic secrets, faster builds). 

### Users

Like Coder v1, you can [enable SSO via OpenID Connect](https://coder.com/docs/coder-oss/latest/install/auth#step-2-configure-coder-with-the-openid-connect-credentials) so that any user in your federation can log in.

3Coder v2 optionally supports [GitHub (Enterprise)](https://coder.com/docs/coder-oss/latest/install/auth#step-1-configure-the-oauth-application-in-github) and [username/password](https://coder.com/docs/coder-oss/latest/users) authentication.

User-wide settings (e.g. avatar, shell, autostart times, dotfiles URL) are not currently supported in Coder v2 (#) but this behavior can often be replicated via workspace-level parameters. See the [feature comparion](#feature-comparison) below for more details.

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

If you 


### Workspaces

To migrate Coder v1 workspaces, you'll need at least one [template](https://coder.com/docs/coder-oss/latest/templates)
in your Coder v2 deployment, specifically with the image(s) you support in Coder v1.


> If you are interested in a bulk workspace migration utility, [we'd like to
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
coder2 config-ssh

# Use rsync to copy your home directory into the new workspace
rsync \
    --recursive \
    --itemize-changes \
    --info=progress2 \
    --links \
    --exclude='.cache/' \
    $HOME/. coder.$CODER_WORKSPACE_NAME:/home/coder/.
```

### Infrastructure

