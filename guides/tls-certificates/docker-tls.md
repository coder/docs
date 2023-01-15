# Configure TLS on Coder for Docker

This guide walks you through configuring TLS on your Coder for Docker deployment
using a reverse proxy.

## Requirements

- A machine with [Docker Engine](https://docs.docker.com/engine/install/) and
  [Docker Compose](https://docs.docker.com/compose/) installed
- A domain name
- An SSL/TLS certificate

## (Optional) Step 1: Validate the LetsEncrypt DNS

> If you already have an TLS certificate, you can skip this step.

This step shows you how to get a free TLS certificate for your domain. Your
domain must be set up with a
[supported DNS provider](https://certbot.eff.org/hosting_providers).

1. Create a `docker-compose.yaml` file with the code below (make sure that you
   replace the `URL`, `DNSPLUGIN`, and `EMAIL` variables with the appropriate
   values):

```yaml
version: "3"
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

Leave the `volumes` section of the code snippet as-is. Docker will automatically
create the `~/letsencrypt` folder and populate it with the contents of the
container. In this case, the contents will be `.ini` files for your DNS
provider.

1. Run `docker-compose up -d`, and navigate to `~/letsencrypt/dns-conf`.

1. Update your DNS provider's `.ini` file with the requested values.

1. Restart the container by running `docker-compose restart letsencrypt`.

You should now see your TLS certificate file in
`~/letsencrypt/etc/letsencrypt/live/example.com`

## Step 2: Configure the Nginx reverse proxy and the Coder container

To properly start the NGINX reverse proxy, you'll need an `nginx.conf` file
present on the host machine.

1. Create a `docker-compose.yaml` file if you have not yet done so.

1. Create an `nginx` folder in the same directory as your `docker-compose.yaml`
   file.

1. Create an `nginx.conf` file inside of the `nginx` directory that includes the
   following code (make sure that you replace each `<your-domain.com>` string
   with your domain):

   > If you skipped **Step 1**, replace the `ssl_certificate` &
   > `ssl_certificate_key` paths with the path to your certificate files.

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
  image: codercom/coder:1.27.0
  container_name: coder
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - ~/.coder:/var/run/coder
  ports:
    - 7080:7080
  environment:
    - DEVURL_HOST=*.<your-domain.com>
```

> The `~/letsecnrypt:/letsencrypt/` volume definition is required only if you
> followed **Step 1**.

## Step 3: Configure and access Coder

Now that NGINX and the Coder containers are configured, run your Docker Compose
file:

```console
docker-compose up -d
```

Finally, in the Coder UI, navigate to **Manage** > **Admin** >
**Infrastructure**. and provide your domain name in the **Access URL** field.

You should now be able to access Coder via your secure domain.
