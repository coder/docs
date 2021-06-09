---
title: "Workspace template code completion"
description: "A better experience to creating workspace templates."
state: beta
---

With 1.20 a feature was implemented that provides some level of code completion when editing workspaces as code template files. This code completion is provided through [json schemas](https://json-schema.org/).

# Requirements

- A coder deployment
- VS-Code
  - [YAML Extension by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)

# How to Use

At the top of your `coder.yaml` file add the following comment. Make sure to replace `<deployment_url>` with your Coder deployment url. Once you have this line in your file, you can begin to use the code completion. 

```yaml
# yaml-language-server: $schema=https://<deployment_url>/api/private/template/schemas/wac.schema.json
```


Helpful Keyboard Shortcuts: (see extension page for more info)
- Document Outlining (Ctrl + Shift + O)
- Auto completion (Ctrl + Space)

![Code Completion Demo](../../assets/wac-intellisense-demo.gif)
