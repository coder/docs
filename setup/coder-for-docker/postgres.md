# External database setup

If you'd like to use an external database with your Coder for Docker deployment,
you must:

1. Disable the embedded database by setting the `DB_EMBEDDED` environment
   variable (see the next code snippet for an example)
1. Provide the connection information to the external PostgreSQL database:

   ```console
   docker run --rm -it -p 7080:7080 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v ~/.coder:/var/run/coder \
      # Disable using the embedded DB
      -e DB_EMBEDDED="" \
      # Change these values to match those for your database
      -e DB_HOST=127.0.0.1 \
      -e DB_PORT=5432 \
      -e DB_USER=postgres \
      -e DB_PASSWORD="" \
      -e DB_NAME=postgres \
      -e DB_SSL_MODE=disable \
      codercom/coder:1.28.2
   ```

Coder supports client TLS certificates using `DB_SSL_MODE=verify-full`. Ensure
that you mount the certs into the container (and add the flag
`-v <local_certs>:/certs`). Then, specify the certificate path using environment
variables:

<!-- markdownlint-disable -->

| **Flag/environment variable**     | **Description**                              |
| --------------------------------- | -------------------------------------------- |
| `-e DB_CERT=/certs/client.crt`    | The path to the client cert signed by the CA |
| `-e DB_KEY=/certs/client.key`     | The path to the client secret                |
| `-e DB_ROOT_CERT=/certs/myCA.crt` | The path to the trusted CA cert              |

<!-- markdownlint-enable -->
