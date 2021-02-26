
Custom images allow you to define workspaces that include the dependencies,
scripts, and user preferences helpful for your project.

> If you're unfamiliar with how to create, build, and push Docker Images, please
see [this tutorial by
Docker](http://blog.shippable.com/build-a-docker-image-and-push-it-to-docker-hub)
before proceeding.

## Creating a Custom Image

Rather than starting from scratch, we recommend extending one of our [example
images](https://github.com/cdr/enterprise-images):

```Dockerfile
# Dockerfile
FROM codercom/enterprise-base:ubuntu

RUN apt-get install -y ...
COPY file ./

...
```

### Notes

- If you're using a different base image, see our [image minimum
  requirements](https://github.com/cdr/enterprise-images/#image-minimums) to
  make sure that your image will work with all of Coder's features.

- You can build images inside a Coder workspace using the [Docker
  Sandbox](https://github.com/bpmct/cdr-images/tree/master/docker-sandbox). If,
  however, you're using [CVMs](#), you'll need to have the [sysbox
  runtime](https://github.com/nestybox/sysbox) on your machine.

## Samples

The following are code snippets that you can use in your Dockerfiles or
configuration scripts.

### Installing an IntelliJ IDE

This snippet shows you how to install an IntelliJ IDE onto your image so that
you can use it in your Coder workspace.

```Dockerfile
# Dockerfile
FROM ...

# Install IDEs as root
USER root

RUN mkdir -p /opt/[IDE]
RUN curl -L "https://download.jetbrains.com/product?code=[CODE]&latest&distribution=linux" | tar -C /opt/[IDE] --strip-components 1 -xzvf
RUN ln -s /opt/[IDE]/bin/clion.sh /usr/bin/[IDE]
```

Make sure that you replace `[IDE]` with the name of the IDE in lowercase and
provide its [corresponding
`[CODE]`](https://plugins.jetbrains.com/docs/marketplace/product-codes.html).

For example, the following installs the CLion IDE onto your image:

```Dockerfile
# Dockerfile
FROM ...

USER root

# Install CLion
RUN mkdir -p /opt/clion
RUN curl -L "https://download.jetbrains.com/product?code=CL&latest&distribution=linux" | tar -C /opt/clion --strip-components 1 -xzvf
RUN ln -s /opt/clion/bin/clion.sh /usr/bin/clion
```

### Creating a Configure Script

If present, Coder runs the configure script once it starts your workspace and
mounts your home directory.

You can use the configure script to:

- Run [Coder CLI](https://github.com/cdr/coder-cli) commands
- Clone a GitHub repo
- Install global npm packages
- Run scripts that use [CODER\_\* environment variables](#)

To create the configure file:

```shell
$ touch configure
$ chmod +x configure
```

The following snippet demonstrates how you can copy Coder's configure script
into yours before your customize it:

```Dockerfile
# Dockerfile

FROM ...

COPY configure /coder/configure
```

### Extending a Configure Script in a Base Image

If you're extending a Coder image that has a configure file that you'd like to
preserve, the following steps show you how to avoid writing over the original
script.

1. Create the configure script

    ```shell
    touch configure
    chmod +x configure
    ```

1. Modify the image's Dockerfile to move the original configure script (this
   results in Coder using the configure script that you created in the previous
   step while preserving the original script)

    ```Dockerfile
    # Dockerfile

    FROM codercom/enterprise-configure:ubuntu

    USER root

    RUN mv /coder/configure /coder/configure-first

    # Add the new configure script
    COPY configure /coder/configure
    ```

1. Create a script that runs the configure script that came with the base image

    ```sh
    # Configure

    # Run the initial configure script
    sh /coder/configure-first

    print "And some more commands..."
    ...
    ```

### Running Coder CLI Commands

The following shows how to run a Coder CLI command in your configure script by
demonstrating how you can create/update a Dev URL:

```sh
# configure

coder ...

# Create a Dev URL (or update if it already exists)
coder urls create $CODER_ENVIRONMENT_NAME 3000 --name webapp
```

## Clone a Git Repo

To check for the presence of a Git repo (and clone if not found):

```sh
# configure

if [ ! -d "/home/coder/workspace/project" ]
then
  git clone git://company.com/project.git /home/coder/workspace/project
else
  echo "Project has already been cloned :)"
fi
```

### Changing VS Code Settings

1. Create a `settings.json` file:

    ```sh
    touch settings.json
    chmod +x settings.json
    ```

2. Add settings info to your file:

    ```json
    {
    "git.enableSmartCommit": true,
    "git.confirmSync": false,
    "editor.formatOnSave": true
    }
    ```

3. Update configure to use the settings file:

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

## Sample Images

To get an idea of what you can include in your images, see:

- [Ben's Coder Images](https://github.com/bpmct/cdr-images) (frequently referred
  to in [Coffee and Coder](https://community.coder.com/coffee-and-coder) and the
  [Coder blog](https://coder.com/blog))
- [Enterprise Example Images](https://github.com/cdr/enterprise-images)
