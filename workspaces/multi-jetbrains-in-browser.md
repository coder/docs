---
title: "Multiple JetBrains Instances"
description:
  Learn how to configure multiple instances of JetBrains IDEs in a browser.
---

These are the steps to build a custom image, configure script, and config.yaml
(using Workspace Applications) to surface additional JetBrains IDE instances in
a browser. This example uses IntelliJ IDEA Ultimate but other JetBrains IDEs can
be used.

> Using additional JetBrains IDEs consume additional workspace compute resources
> so ensure the workspace compute resources settings are large enough.

![Multiple IntelliJ icons in a
workspace](../assets/workspaces/multi-intellij-icons-smaller.png)

1. Build a custom image that installs the primary JetBrains IDE, copies the
   configure script, .profile script, and the config.yaml file into the image.

    ```Dockerfile
    FROM codercom/enterprise-java:ubuntu

    USER root

    # Install IntelliJ IDEA Ultimate
    RUN mkdir -p /opt/idea
    RUN curl -L \
    "https://download.jetbrains.com/product?code=IU&latest&distribution=linux" \
    | tar -C /opt/idea --strip-components 1 -xzvf -

    # Create a symbolic link in PATH that points to the Intellij startup script.
    RUN ln -s /opt/idea/bin/idea.sh /usr/bin/intellij-idea-ultimate

    # bash .profile so projector can be added to the path
    COPY [".profile", "/coder/.profile"]

    # configure script
    COPY ["configure", "/coder/configure"]
    RUN chmod +x /coder/configure

    # copy custom apps info (config.yaml)
    COPY ["./coder", "/coder"]

    # Set back to coder user
    USER coder
    ```

    This is the .profile script to add the Projector CLI to the workspace's
    path. In this example, .profile is located in a coder directory within the
    directory that has the image Dockerfile.

    ```console
    export PATH=$PATH:$HOME/.local/bin
    ```

1. The configure script installs the Projector CLI into `/home/coder` and uses
   the CLI to install additional JetBrains IDEs. Each IDE configuration has a
   different directory in `/home/coder/.projector/configs`. In this example, the
   configure script in the directory that has the image Dockerfile.

    > Note that each additional IDE needs a different port number

    ```console
    # install projector into /home/coder/ pvc
    pip3 install projector-installer --user

    # put projector CLI into path
    cp /coder/.profile $HOME
    source $HOME/.profile

    # autoinstall intellij version specifying config name and port
    $HOME/.local/bin/projector --accept-license

    PROJECTOR_CONFIG_PATH=$HOME/.projector/configs/IntelliJ_2

    if [ -d $PROJECTOR_CONFIG_PATH ]; then
        echo 'projector has already been configured - skip step'
    else
        $HOME/.local/bin/projector ide autoinstall --config-name IntelliJ_2 \ 
        --ide-name "IntelliJ IDEA Ultimate 2021.3.2" --port 8997 \
        --use-separate-config
        $HOME/.local/bin/projector ide autoinstall --config-name IntelliJ_3 \
        --ide-name "IntelliJ IDEA Ultimate 2021.3.2" --port 8998 \
        --use-separate-config
        $HOME/.local/bin/projector ide autoinstall --config-name IntelliJ_4 \
        --ide-name "IntelliJ IDEA Ultimate 2021.3.2" --port 8999 \
         --use-separate-config  
    fi    
    ```

1. This is the `config.yaml` file used by Workspace Applications to surface
   icons for each additional JetBrains IDE in the workspace dashboard. The
   configuration uses the JetBrains icon used with the initial JetBrains IDE
    installed. In this example, config.yaml is located in a coder/apps directory
    within the directory that has the image Dockerfile.

   > Note that each workspace application name must be unique so that Projector
   > knows which config directory to point to

   ```yaml
   # /coder/apps/config.yaml
    apps:
      # Name of application in launcher. Name may consist of alphanumeric
      # characters, dashes, underscores. Names must begin with an alphanumeric
      # character. Names must be unique per application. Required.
      - name: IntelliJ IDEA Ultimate 2
        # Application scheme - must be http or https. Required.
        scheme: http
        # Application port. Required.
        port: 8997
        # Host of the application to use when dialing. Defaults to localhost.
        # Optional.
        host: "localhost"
        # Working directory for the start command. Required.
        working-directory: /home/coder
        # File path to icon used in application launcher. Icons should be either
        # PNG, SVG, or JPG. Required.
        icon-path: /opt/idea/bin/idea.svg
        # Command to start the application. Required.
        command: /home/coder/.projector/configs/IntelliJ_2/run.sh
        # Array of arguments for command. Optional.
        args: [""]
        # Health checks to get running application status. Can use exec or http
        # health checks to localhost. Optional, but we recommend specifying a
        # health check. If you don't supply one, then an http request is sent to
        # the application root path "/".
        health-check:
          http:
            # Scheme must be "http" or "https". If not specified it inherits
            # the application scheme. Optional.
            scheme: "http"
            # The host to use when dialing the address. If not specified it
            # inherits the application host. Optional.
            host: "localhost"
            # Port to use when dialing the application. If not specified it
            # inherits the application port. Optional.
            port: 8997
      - name: IntelliJ IDEA Ultimate 3
        # Application scheme - must be http or https. Required.
        scheme: http
        # Application port. Required.
        port: 8998
        # Host of the application to use when dialing. Defaults to localhost.
        # Optional.
        host: "localhost"
        # Working directory for the start command. Required.
        working-directory: /home/coder
        # File path to icon used in application launcher. Icons should be either
        # PNG, SVG, or JPG. Required.
        icon-path: /opt/idea/bin/idea.svg
        # Command to start the application. Required.
        command: /home/coder/.projector/configs/IntelliJ_3/run.sh
        # Array of arguments for command. Optional.
        args: [""]
        # Health checks to get running application status. Can use exec or http
        # health checks to localhost. Optional, but we recommend specifying a
        # health check. If you don't supply one, then an http request is sent to
        # the application root path "/".
        health-check:
          http:
            # Scheme must be "http" or "https". If not specified it inherits
            # the application scheme. Optional.
            scheme: "http"
            # The host to use when dialing the address. If not specified it
            # inherits the application host. Optional.
            host: "localhost"
            # Port to use when dialing the application. If not specified it
            # inherits the application port. Optional.
            port: 8998
      - name: IntelliJ IDEA Ultimate 4
        # Application scheme - must be http or https. Required.
        scheme: http
        # Application port. Required.
        port: 8999
        # Host of the application to use when dialing. Defaults to localhost.
        # Optional.
        host: "localhost"
        # Working directory for the start command. Required.
        working-directory: /home/coder
        # File path to icon used in application launcher. Icons should be either
        # PNG, SVG, or JPG. Required.
        icon-path: /opt/idea/bin/idea.svg
        # Command to start the application. Required.
        command: /home/coder/.projector/configs/IntelliJ_4/run.sh
        # Array of arguments for command. Optional.
        args: [""]
        # Health checks to get running application status. Can use exec or http
        # health checks to localhost. Optional, but we recommend specifying a
        # health check. If you don't supply one, then an http request is sent to
        # the application root path "/".
        health-check:
          http:
            # Scheme must be "http" or "https". If not specified it inherits
            # the application scheme. Optional.
            scheme: "http"
            # The host to use when dialing the address. If not specified it
            # inherits the application host. Optional.
            host: "localhost"
            # Port to use when dialing the application. If not specified it
            # inherits the application port. Optional.
            port: 8999

> Here are links to Projector CLI documentation for
> [installation](https://github.com/JetBrains/projector-installer#Installation)
> and [CLI
> commands](https://github.com/JetBrains/projector-installer/blob/master/COMMANDS.md)
