---
title: "Applications"
description:
  Learn how to access web applications running on your remote workspace.
state: beta
---

You can connect to web applications installed on your workspace using the
applications specification file located at `/coder/apps/config.yaml` of the
workspace filesystem.

![Application Launcher](../assets/workspaces/applications.png)

## Application specification file

The application specification file allows you to define what Coder needs to
launch the application. Within the file, you can specify the following for each
application:

```yaml
# /coder/apps/config.yaml

apps:
  # Name of application in launcher
  - name: projector
    # Application scheme
    scheme: http
    # Application port
    port: 9999
    # Working directory
    dir: /home/coder
    # File path to icon used in application launcher
    icon_path: /home/coder/goland.svg
    # Command to start the application
    command: /home/coder/.local/bin/projector
    # Array of arguments for command
    args: ["run"]
    # Health checks to get running application status
    # Can use exec or http health checks to localhost
    health_check:
      exec:
        command: "pgrep"
        args: ["projector"]
      http:
        scheme: "http"
        path: "/"
        port: 9999
```

You can include the applications specification file in your
[workspace image](../images/writing.md). You an also modify the file via
[personalization](./personalization.md) scripts.
