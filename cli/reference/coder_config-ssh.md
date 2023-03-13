# coder config-ssh

Configure SSH to access Coder workspaces

### Synopsis

Inject the proper OpenSSH configuration into your local SSH config file.

```text
coder config-ssh [flags]
```

### Options

```text
      --filepath string   override the default path of your ssh config file (default "~/.ssh/config")
  -h, --help              help for config-ssh
  -o, --option strings    additional options injected in the ssh config (ex. disable caching with "-o ControlPath=none")
      --remove            remove the auto-generated Coder ssh config
```

### Options inherited from parent commands

```text
  -v, --verbose   show verbose output
```

### SEE ALSO

- [coder](coder.md) - coder provides a CLI for working with an existing Coder
  installation
