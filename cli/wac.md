---
title: "Workspaces as Code"
description: "Learn about the start of Workspaces as Code (WAC)."
state: alpha
---

> **Caution:** Workspaces as Code is still in its infancy, and subject to
> heavy change. This feature should only be explored by advanced users at
> this time.

Workspaces as Code has secretly made its way into the v1.16.0 release!  

Workspaces as Code is a feature that allows a workspace to be configured and
version controlled as code. A yaml document can now be used instead of a web
form to create a workspace. In the future, this enables a more rich set
of features when configuring a workspace.

## Creating a Workspace with WAC

The easiest way to create a workspace from a yaml document is to use the
`coder` command line utility. The `coder` cli has a hidden command,
that can be previewed with:

```bash
coder envs create-from-config --help
```

First a yaml document describing a workspace needs to be created, call it
`wac_template.yaml`:

> **Caution:** This yaml format is heavily subject to change

```yaml
# wac_template.yaml
version: 0.0
workspace:
  name: "wacky-env"
  organization: "default"
  kubernetes:
    # Image should already be registered in your coder's organization.
    # Use the image's repo name.
    image: ubuntu
    container-based-vm: true
    resources:
      cpu: 2
      memory: 8
      disk: 30
```

Now we can create our env from this template:

```bash
$ coder envs create-from-config --org default -f wac_template.yaml
success: creating environment...
  | 
  | tip: run "coder envs watch-build wacky-env" to trail the build logs
```

## Known Issues

The first release of WAC is very sensitive to certain inputs. At this time,
the reported errors to the cli are not descriptive or helpful, so making
any mistake with the yaml or process will be difficult to debug.
Common issues will likely involve:

- The image name not being found.
- If using `--ref` instead of passing a file directly, the oauth app might
  not be found to fetch the git repo.
- The organization in the yaml is currently ignored, so using the cli flag
  `--org` is recommended in this mvp state.
  