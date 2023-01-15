# Workspace applications

You can connect to web applications installed on your workspace using an
applications specification file located at `/coder/apps/config.yaml` of the
workspace filesystem.

![Application Launcher](../assets/workspaces/applications.png)

## Enabling workspace applications

If you'd like to use workspace applications in Coder, you can enable this
feature in the UI:

1. In the top-right, click on your avatar and select **Feature Preview**.
1. Click **Workspace applications** and select **Enable**.

## Application specification file

To define workspace applications, add a configuration file at
`/coder/apps/config.yaml` to your image.

The config file specifies the parameters Coder requires to launch the
application. Here is a sample `config.yaml` for adding a Python HTTP server as a
workspace application. Note that this requires the `python3` binary, which is
included in Coder's base images.

```yaml
# /coder/apps/config.yaml

apps:
  # Name of application in launcher. Name may consist of alphanumeric
  # characters, dashes, underscores. Names must begin with an alphanumeric
  # character. Names must be unique per application. Required.
  - name: HTTP server
    # Application scheme - must be http or https. Required.
    scheme: http
    # Application port. Required.
    port: 8000
    # Host of the application to use when dialing. Defaults to localhost.
    # Optional.
    host: "localhost"
    # Working directory for the start command. Required.
    working-directory: /home/coder
    # File path to icon used in application launcher. Icons should be either
    # PNG, SVG, or JPG. Required.
    icon-path: /home/coder/python-logo.png
    # Command to start the application. Required.
    command: python3
    # Array of arguments for command. Optional.
    args: ["-m", "http.server"]
    # Health checks to get running application status. Can use exec or http
    # health checks to localhost. Optional, but we recommend specifying a
    # health check. If you don't supply one, then an http request is sent to
    # the application root path "/".
    health-check:
      # Exec commands require an exit code of '0' to report healthy.
      exec:
        command: "pgrep"
        args: ["python3"]
      # http sends a GET request to the address specified via the parameters.
      # Expects the status codes to match; default is HTTP 200.
      http:
        # Scheme must be "http" or "https". If not specified it inherits
        # the application scheme. Optional.
        scheme: "http"
        # The host to use when dialing the address. If not specified it
        # inherits the application host. Optional.
        host: "localhost"
        # Port to use when dialing the application. If not specified it
        # inherits the application port. Optional.
        port: 8000
        # Path to use for the health check. If not specified defaults to
        # "/". Optional.
        path: ""
```

**Notes**:

- A health check _must_ report healthy for you to access the application.
- If you specify both the HTTP and Exec health checks, Coder prioritizes HTTP.

### Image creation

When creating your image, be sure to:

1. In the folder where your Dockerfile is, add a `coder/apps` folder
1. Add the `config.yaml` you created to `coder/apps`.
1. Add the icon that you would like Coder to render for your app to the
   `coder/apps` folder
1. Add a step to your Dockerfile to copy the `coder` folder into the image:

```text
# copy custom apps info (config.yaml)
COPY ["./coder", "/coder"]
```

## Sample usage

Coder offers an [image](https://hub.docker.com/r/codercom/enterprise-vnc) that
helps you [set up a VNC](../guides/customization/vnc.md). With a VNC available,
you can add an icon to your **Browser applications** via setting the
[config file](https://github.com/coder/enterprise-images/blob/91ef8f521b2275783fed54b27052cc544153cd99/images/vnc/coder/apps/config.yaml).

You are welcome to try the
[public Dockerfile repo that contains the example above](https://github.com/mtm20176/dockerfiles/tree/main/python/workspace-apps).
The repo includes config files that set up Python and Node.js HTTP servers and
the accompanying icons.

You can also see our
[blog post](https://coder.com/blog/run-any-application-or-ide-in-coder) for
further samples on adding tools like Portainer, Insomnia, and various versions
of code-server.
