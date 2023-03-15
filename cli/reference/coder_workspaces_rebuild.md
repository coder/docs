# coder workspaces rebuild

rebuild a Coder workspace

```text
coder workspaces rebuild [workspace_name] [flags]
```

### Examples

```text
coder workspaces rebuild front-end-workspace --follow
coder workspaces rebuild backend-workspace --force
```

### Options

```text
      --follow        follow build log after initiating rebuild
      --force         force rebuild without showing a confirmation prompt
  -h, --help          help for rebuild
      --user string   Specify the user whose resources to target (default "me")
```

### Options inherited from parent commands

```text
  -v, --verbose   show verbose output
```

### SEE ALSO

- [coder workspaces](coder_workspaces.md) - Interact with Coder workspaces
