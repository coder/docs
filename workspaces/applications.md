---
title: "Applications"
description:
  Learn how to access web applications running on your remote workspace.
state: alpha
---

Coder connects developers to web applications installed in their workspaces by
using an applications specification file file located at
`/coder/apps/config.yaml` on the workspace filesystem.

## Application Specification File

You may specify the following options for an application:

```yaml
# /coder/apps/config.yaml

apps:
  # Name of application in launcher
  - name: python
    # Application scheme
    scheme: http
    # Application port
    port: 8000
    # Working directory
    dir: /home/coder
    # File path to icon used in launcher
    icon_path: /home/coder/1920px-Python.svg.png
    # Command to start the application
    command: python
    # Array of arguments for command
    args: ["-m", "SimpleHTTPServer"]
    # Health checks to get running application status
    # Can use exec or http health checks to localhost
    #
    # health_check:
    #   # Exec health check:
    #   exec:
    #     command: "pgrep"
    #     args: ["python"]
    #
    #   # HTTP health check:
    #   http:
    #     scheme: "http"
    #     path: "/"
    #     port: 8080
    health_check:
      exec:
        command: "pgrep"
        args: ["python"]
```

The applications specification file can be written into the workspace image and
also supports editing via [personalization](./personalization.md) scripts.
