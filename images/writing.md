---
title: "Writing Custom Images"
description: Create custom images for Coder.
---

It often makes sense to create custom images that include the dependencies, scripts, preferences necessary for development. For information on how to create, build, and push Docker images, see [this tutorial by Docker](http://blog.shippable.com/build-a-docker-image-and-push-it-to-docker-hub). Images can be pushed to any container registry accessible by Coder.

We recommend starting with one of our [example images](https://github.com/cdr/enterprise-images) and extending them. If you need to use another base image, read over our [image minimums](https://github.com/cdr/enterprise-images/#image-minimums) to ensure your image works with all Coder features.

```Dockerfile
FROM codercom/enterprise-base:ubuntu

RUN apt-get install -y ...
COPY file ./

...
```

📝: You can build most images inside a Coder workspace! Check out [this image](https://github.com/bpmct/cdr-images/tree/master/docker-sandbox) for info. However, in order to build images with CVM-specific features, you will need to be running the [sysbox runtime](https://github.com/nestybox/sysbox) on your machine.

## Snippets

Below are some Coder-specific code snippets that can be used in Dockerfiles and/or configure scripts.

### Installing an IntelliJ IDE

```Dockerfile
# Dockerfile

FROM ...

USER root # Install IDEs as root

RUN mkdir -p /opt/[IDE]
RUN curl -L "https://download.jetbrains.com/product?code=[CODE]&latest&distribution=linux" | tar -C /opt/[IDE] --strip-components 1 -xzvf
RUN ln -s /opt/[IDE]/bin/clion.sh /usr/bin/[IDE]
```

Replace `[IDE]` with the name of the IDE in lowercase. To find the corresponding `[CODE]`, use [this reference](https://plugins.jetbrains.com/docs/marketplace/product-codes.html).

ex. (CLion IDE):

```Dockerfile
# Dockerfile

FROM ...

USER root

# install CLion
RUN mkdir -p /opt/clion
RUN curl -L "https://download.jetbrains.com/product?code=CL&latest&distribution=linux" | tar -C /opt/clion --strip-components 1 -xzvf
RUN ln -s /opt/clion/bin/clion.sh /usr/bin/clion

```

### Configure script

The `configure` script will run once your workspace has started and your the home directory has been mounted.

Some good things to do in the configure script:

- Run [coder-cli](https://github.com/cdr/coder-cli) commands
- Clone a GitHub repo
- Install global npm packages
- Run scripts that use [CODER\_\* environment variables](https://help.coder.com/hc/en-us/articles/360059484653-Working-with-CODER-Environment-Variables)

Create the `configure` file in the same directory as your Dockerfile:

```shell
$ touch configure
$ chmod +x configure
```

```Dockerfile
# Dockerfile

FROM ...

COPY configure /coder/configure
```

### Extending a configure script from a base image

If you're extending a Coder image that has a configure script, you can use this workaround to avoid overwriting the original script. This will run AFTER the initial script runs.

```shell
$ touch configure
$ chmod +x configure
```

```Dockerfile
# Dockerfile

FROM codercom/enterprise-configure:ubuntu

USER root

RUN mv /coder/configure /coder/configure-first

# Add the new configure script
COPY configure /coder/configure
```

```sh
# configure

# Run the initial configure script
sh /coder/configure-first

print "And some more commands..."

...

```

### Run coder-cli commands

```sh
# configure

coder ...

# Create a Dev URL (or update if it already exists)
coder urls create $CODER_ENVIRONMENT_NAME 3000 --name webapp
```

### Clone a git repo:

```sh
# configure

if [ ! -d "/home/coder/workspace/project" ]
then
  git clone git://company.com/project.git /home/coder/workspace/project
else
  echo "Project has already been cloned :)"
fi
```

### Set initial VS Code Settings (and extensions)

```sh
$ touch settings.json
$ chmod +x settings.json
```

example settings.json:

```json
{
  "git.enableSmartCommit": true,
  "git.confirmSync": false,
  "editor.formatOnSave": true
}
```

```sh
# configure

# Check if there are existing settings
if [ -f "/home/coder/.local/share/code-server/User/settings.json" ]
then
    echo "VS Code settings are already present. Remove with and run /coder/configure to revert to defaults"
else
    cp settings.json /home/coder/.local/share/code-server/User/settings.json

    # Install extensions
    /opt/coder/code-server/bin/code-server --install-extension esbenp.prettier-vscode
fi
```

## Sample images

- [Ben's Coder Images](https://github.com/bpmct/cdr-images) (referenced in [Coffee and Coder](https://community.coder.com/coffee-and-coder) and the [Coder blog](https://coder.com/blog))
- [Enterprise Example Images](https://github.com/cdr/enterprise-images)
