---
title: "Upgrade"
description: Learn how to upgrade your Coder for Docker deployment.
---

This guide will show you how to upgrade your Coder for Docker deployment.

To upgrade, run the following command to download the resources you need,
including the latest images (ensure that you're providing the correct version
number in the command, e.g., `1.32.0`):

```console
docker run --rm -it \
    -p 7080:7080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.coder:/var/run/coder \
    codercom/coder:<version>
```

## Docker Compose

If you use Docker Compose to run Coder, here's how to upgrade your deployment:

1. Update the Coder the version in your `docker-compose-yml` file:

   ```yml
   # ...
   services:
   coder:
     image: docker.io/codercom/coder:1.32.0
     # ...
   ```

1. Recreate your image:

   ```console
   docker-compose up --force-recreate --build -d
   ```

1. Start the container:

   ```console
   docker-compose up
   ```
