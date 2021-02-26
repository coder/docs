---
title: "Workspaces as Code"
description: "Learn about the start of Workspaces as Code (WAC)."
state: alpha
---

> **Caution:** Workspaces as Code is a work-in-progress feature introduced in
> v1.16.0. It is subject to significant changes and should only be implemented
> and used by advanced users at this time.

Workspaces as Code is a feature that allows you to configure and version control
a workspace the way you would software code. You can define your workspace using
a YAML file, which Coder uses instead of a web form to create your workspace.

## Creating a Workspace

Creating a workspace requires two steps:

1. Creating the YAML file and defining your workspace
2. Using the Coder CLI to create the workspace using your YAML file:

  ```bash
  coder envs create-from-config [flags]
  ```

1. Create the YAML file that describes the workspace using the text editor of
   your choice. Name the file `wac_template.yaml`:

  **Caution:** The YAML template is subject to change.

  ```yaml
  # wac_template.yaml
  version: 0.0
  workspace:
    name: "your-env"
    organization: "default"
    kubernetes:
      # Image should already be imported and available to your Coder
      # organization. Use the image's repo name.
      image: ubuntu
      container-based-vm: true
      resources:
        cpu: 2
        memory: 8
        disk: 30
  ```

2. Use the Coder CLI to create the workspace using your YAML file:

  ```bash
  $ coder envs create-from-config --org <YOUR_CODER_ORG> -f wac_template.yaml
  success: creating environment...
  ```

  If you'd like to trail the build logs during this process, you can USE:

  ```bash
  coder envs watch-build <YOUR_NEW_ENVIRONMENT>
  ```
  
## Known Issues

At this time, the errors returned to the CLI aren't descriptive, so debugging
mistakes in the YAML file or process errors will be challenging.

However, we expect common errors to involve:

- The image not being found
- The OAuth app not being found to fetch the git repo if you use `--repo_url`
  instead of passing a file directly

Finally, Coder currently ignores the organization name in the YAML file, so we
recommend using the CLI command flag `--org` at this time.