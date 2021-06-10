---
title: "Workspace template code completion"
description: "A better experience to creating workspace templates."
state: beta
---



Coder provides a [JSON Schema](https://json-schema.org/) for Workspace
Templates which enables support for completion and syntax checking.
[YAML Extension by Red Hat](
https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
is required to use this feature.

## How to Use

At the top of your `coder.yaml` file add the following comment. Make sure
to replace `<deployment_url>` with your Coder deployment URL.
If the extension is installed, then your file will have code completion.

```yaml
# yaml-language-server: $schema=https://<deployment_url>/api/private/template/schemas/wac.schema.json

# Write your yaml config here
```

Helpful Keyboard Shortcuts: (see extension page for more info)

- Document Outlining (<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>O</kbd>)
- Auto completion (<kbd>Ctrl</kbd> + <kbd>Space</kbd>)

![Code Completion Demo](../../assets/wac-intellisense-demo.gif)
