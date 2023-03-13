# coder users ls

list all user accounts

```text
coder users ls [flags]
```

### Examples

```text
coder users ls -o json
coder users ls -o json | jq .[] | jq -r .email
```

### Options

```text
  -h, --help            help for ls
  -o, --output string   human | json (default "human")
```

### Options inherited from parent commands

```text
  -v, --verbose   show verbose output
```

### SEE ALSO

- [coder users](coder_users.md) - Interact with Coder user accounts
