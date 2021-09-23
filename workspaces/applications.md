---
title: "Applications"
description: Learn how to access web apps running in your workspace.
state: beta
---

You can connect to web applications installed on your workspace using the
applications specification file located at `/coder/apps/config.yaml` of the
workspace filesystem.

![Application Launcher](../assets/workspaces/applications.png)

## Enabling custom apps

If you'd like to use custom apps in Coder, you can enable this feature in the
UI:

1. In the top-right, click on your avatar and select **Feature Preview**
1. Click **Generic applications** and select **Enable**.

## Application specification file

In order to specify custom applications, add a configuration file at path
`/coder/apps/config.yaml` to your image.

The config file specifies the parameters Coder requires in order to
launch the application. Within the file, you can specify the following for each
application:

```yaml
# /coder/apps/config.yaml

apps:
    # Name of application in launcher. Name may consist of alphanumeric
    # characters, dashes, underscores. Names must begin with an alphanumeric
    # character. Names must be unique per application. Required.
    # Regex used "^[a-zA-Z0-9]+[a-zA-Z0-9-_ ]{0,62}$".
  - name: projector
    # Application scheme - must be http or https. Required.
    scheme: http
    # Application port. Required.
    port: 9999
    # Host of the application to use when dialing. Defaults to localhost.
    # Optional.
    host: "localhost"
    # Working directory for the start command. Required.
    working-directory: /home/coder
    # File path to icon used in application launcher. Icons should be either
    # PNG, SVG, or JPG.
    icon-path: /home/coder/goland.svg
    # Command to start the application. Required.
    command: /home/coder/.local/bin/projector
    # Array of arguments for command. Optional.
    args: ["run"]
    # Health checks to get running application status. Can use exec or http
    # health checks to localhost. It is recommended to specify a health-check
    # although not strictly required. If one is not supplied then an http
    # request is sent to the application root path "/".
    health-check:
      # Exec commands require an exit code of '0' to report healthy.
      exec:
        command: "pgrep"
        args: ["projector"]
      # http sends a GET request to the address specified via the parameters.
      # It expects a 200 status code to report healthy.
      http:
        # Scheme must be "http" or "https". If not specified it inherits
        # the application scheme. Optional.
        scheme: "http"
        # The host to use when dialing the address. If not specified it
        # inherits the application host. Optional.
        host: "localhost"
        # Port to use when dialing the application. If not specified it
        # inherits the application port. Optional.
        port: 9999
        # Path to use for the health check. If not specified defaults to
        # "/".
        path: "/healthz"
```

**Notes**:

- A health check _must_ report healthy in order to access the application.
- If both HTTP and Exec health checks are specified then HTTP is preferred.

You can include the applications specification file in your
[workspace image](../images/writing.md). You an also modify the file via
[personalization](./personalization.md) scripts.
