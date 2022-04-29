---
title: "Multiple JetBrains instances configuration"
description: Learn how to run multiple instances of JetBrains IDEs in Coder.
---

This article walks you through the process of configuring Coder to support the
use of multiple instances of the same JetBrains IDE using the JetBrains
Projector CLI.

![Multiple IntelliJ icons in a
workspace](../../assets/workspaces/multi-intellij-icons-smaller.png)

You will:

1. Create and build the custom image
1. Write the configure script
1. Write the `config.yaml` file needed to utilize Coder's [workspace
   applications] feature to surface additional JetBrains IDE instances in your
   browser

This article shows you how to configure multiple instances of IntelliJ IDEA
Ultimate, but you can use this process for any JetBrains IDEs.

> Using additional JetBrains IDEs consumes extra workspace compute resources, so
> ensure that you've allocated enough resources to your workspace to support all
> of your IDE instances.

1. Build a custom image that installs the primary JetBrains IDE and copies the
   configure script, `.profile` script, and `config.yaml` file to the image:

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

   # Packages required for JetBrains-in-a-browser support
   RUN apt-get update && \
       DEBIAN_FRONTEND="noninteractive" apt-get install -y \
       libxtst6 \
       libxrender1 \
       libfontconfig1 \
       libxi6 \
       libgtk-3-0

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

1. Create the configure script that installs the Projector CLI into
   `/home/coder` and uses the CLI to create additional JetBrains IDE config
   folders. Each IDE configuration has a different directory in
   `/home/coder/.projector/configs`.

   In this example, the configure script is in the directory that contains the
   image's Dockerfile:

   > Each additional IDE requires a unique port number.

   ```console
   # install projector into /home/coder/ pvc
   pip3 install projector-installer --user

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

1. Create the `config.yaml` file used by
   [workspace applications](../../workspaces/applications.md) to surface icons
   for each additional JetBrains IDE in the workspace. The configuration uses
   the JetBrains icon included with the initial JetBrains IDE installed.

   In this example, `config.yaml` is located in a `coder/apps` directory within
   the directory that contains the image Dockerfile.

   > Each workspace application name must be unique so that Projector can point
   > to the correct config directory.

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
   ```

The configure script example above auto-installs the JetBrains IDE into the
`/home/coder` folder. If you have an air-gapped deployment or want to use the
existing Coder-installed JetBrains IDE, replace the auto-install command with
Projector's configure command:

```sh
INTELLIJ_PATH=$HOME/.projector/apps/idea

if [ -d $INTELLIJ_PATH ]; then
    echo 'intellij IDE has already been copied - skip step'
else
    echo 'copying Coder-installed JetBrains IntelliJ IDE into /home/coder'
    cp -R /opt/idea $HOME/.projector/apps
fi

PROJECTOR_CONFIG_PATH=$HOME/.projector/configs/IntelliJ_2

if [ -d $PROJECTOR_CONFIG_PATH ]; then
    echo 'projector has already been configured - skip step'
else
    echo 'creating projector config folders to support running multiple IntelliJ IDEs'
    $HOME/.local/bin/projector config add IntelliJ_2 $HOME/.projector/apps/idea --port 8997 --hostname=localhost --use-separate-config
    $HOME/.local/bin/projector config add IntelliJ_3 $HOME/.projector/apps/idea --port 8998 --hostname=localhost --use-separate-config
    $HOME/.local/bin/projector config add IntelliJ_4 $HOME/.projector/apps/idea --port 8999 --hostname=localhost --use-separate-config
fi
```

If you do not want to use workspace applications (i.e., the icons and
`config.yaml` file), you can create dev URLs for each additional IntelliJ IDE
and launch the `run.sh` script in `.projector/configs/<your config name>` on the
appropriate port.

> See Projector's CLI documentation for additional information on
> [installation](https://github.com/JetBrains/projector-installer#Installation)
> and the
> [CLI commands](https://github.com/JetBrains/projector-installer/blob/master/COMMANDS.md)
> it accepts.
