<!-- markdownlint-disable MD041 -->

# Using Coder to edit the Coder docs

With sandbox.coder.com:

[![Open in
Coder](https://cdn.coder.com/embed-button.svg)](https://sandbox.coder.com.dev/wac/build?project_oauth_service=github&template_oauth_service=github&template_ref=bpmct%2Fadd-coder&template_url=https://github.com/cdr/docs)

Your own deployment:

```text
New workspace > Create from template

Repo url: https://github.com/cdr/docs
```

## In this folder

- [coder.yaml](./config.yaml): Coder
  [workspace template](https://coder.com/docs/coder/latest/workspaces/workspace-templates)
  with image, workspace size, etc
- [Dockerfile](./Dockerfile): Image with config & dependencies for editing the
  docs
- [apps/](./apps/): Custom applications for the workspace
- [extensions/](./apps/): VS Code extension files for code-server

## TODO

- [ ] Add CI to push image
- [ ] Create CodeTour?
- [ ] Look into other IDEs or editors for markdown