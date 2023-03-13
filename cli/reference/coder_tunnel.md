# coder tunnel

proxies a port on the workspace to localhost

### Synopsis

Start a tunnel between this computer and a remove workspace, using a localhost
port.

### Options

```text
      --address string                local address to bind to (default "127.0.0.1")
  -h, --help                          help for tunnel
      --max-retry-duration duration   maximum amount of time to sleep between retry attempts (default 1m0s)
      --retry int                     number of attempts to retry if the tunnel fails to establish or disconnect (-1 for infinite retries)
      --udp                           tunnel over UDP instead of TCP
```

### Options inherited from parent commands

```text
      --coder-token string   API authentication token.
      --coder-url string     access url of the Coder deployment. (default "https://stable.cdr.dev")
  -v, --verbose              show verbose output
```

### SEE ALSO

- [coder](coder.md) - coder provides a CLI for working with an existing Coder
  installation
