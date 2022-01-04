---
title: "Configure TLS on Coder for Docker"
description: Learn how to configure TLS on Coder for Docker
---

This guide walks through how to to configure TLS on your Coder for Docker
instance by using a reverse proxy.

## Requirements

- A machine with Docker Engine installed

- Docker Compose

- A domain

- SSL certificate

## (Optional) Step 1: LetsEncrypt DNS Validation

> If you already have an SSL certificate, you can skip this step.

This step shows you how to get a free SSL certificate for your domain.
Your domain must be set up with a [supported DNS
provider](https://certbot.eff.org/hosting_providers).

1. Create a `docker-compose.yaml` file with the below code, and replace the
   `URL`, `DNSPLUGIN`, and `EMAIL` variables with the appropriate values:

```yaml
version: '3'
services:
  letsencrypt:
    image: linuxserver/letsencrypt
    container_name: letsencrypt
    environment:
      - PUID=1000
      - PGID=1000
      - URL=<your-domain.com>
      - SUBDOMAINS=wildcard
      - VALIDATION=dns
      - DNSPLUGIN="<dns-provider>"
      - EMAIL=eric@coder.com
      - DHLEVEL=4096
    volumes:
      - "~/letsencrypt:/config"
    restart: unless-stopped
```

Leave the `volumes` section as is. Docker will automatically create the
`~/letsencrypt` folder, and populate it with the contents of the container,
which in this case, will be `.ini` files for each DNS provider.

1. Run `docker-compose up -d` and navigate to `~/letsencrypt/dns-conf`

1. Update your DNS provider's `.ini` file with the required values

1. Restart the container by running `docker-compose restart letsencrypt`

You should now see your SSL certificate files in
`~/letsencrypt/etc/letsencrypt/live/example.com`

## Step 2: Configure the Nginx reverse proxy & Coder

To properly start the nginx reverse proxy, you'll need an `nginx.conf` file
present on the host machine.

1. Create a `docker-compose.yaml` file if you have not yet done so

1. Create an `nginx` folder in the same directory as your `docker-compose.yaml`
   file

1. Create an `nginx.conf` file inside of the `nginx` directory and include the
   following code. Replace each `<your-domain.com>` string with your domain.

  ```console
    worker_processes  1;

    events {
        worker_connections  1024;
    }

    http {
        default_type  application/octet-stream;
        map $http_upgrade $connection_upgrade {
            default upgrade;
            ''      close;
        }

        server {
            listen       80;
            listen  [::]:80;
            server_name  <your-domain.com>;

            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   /usr/share/nginx/html;
            }

            location / {
                proxy_pass   http://coder:7080;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr; 
            }
        }

        server {
            listen       443 ssl;
            server_name  <your-domain.com>;
            ssl_certificate      /letsencrypt/etc/letsencrypt/live/<your-domain.com>/cert.pem;
            ssl_certificate_key  /letsencrypt/etc/letsencrypt/live/<your-domain.com>/privkey.pem;
            ssl_session_cache    shared:SSL:1m;
            ssl_session_timeout  5m;
            ssl_ciphers  HIGH:!aNULL:!MD5;
            ssl_prefer_server_ciphers  on;
            location / {
                proxy_pass   http://coder:7080;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
            }
        }

        sendfile        on;
        keepalive_timeout  65;
        proxy_connect_timeout   90;
        proxy_send_timeout      90;
        proxy_read_timeout      90;
    }
  ```

1. Add the following code to your `docker-compose.yaml` file:

```yaml
  nginx:
    container_name: nginx
    hostname: reverse
    image: nginx
    ports:
      - 80:80
      - 443:443
    volumes:
      - "nginx:/etc/nginx"
      - "~/letsencrypt:/letsencrypt/"
  coder:
    hostname: coder
    image: codercom/coder:1.25.1
    container_name: coder
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ~/.coder:/var/run/coder
    ports:
      - 7080:7080
    environment:
      - DEVURL_HOST="*.<your-domain.com>"
```

> The `~/letsecnrypt:/letsencrypt/` volume definition is only required if you
> followed Step 1

## Step 3: Access Coder

Now that the nginx & Coder containers are configured, the last step is to run
your Docker Compose file with the following command:

```console
docker-compose up -d
```

You should now be able to access Coder via your secure domain.

Lastly, update the **Access URL** in the Coder Admin panel by navigating to
**Manage** > **Admin** > **Infrastructure**.
