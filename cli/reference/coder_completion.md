# coder completion

Generate completion script

### Synopsis

To load completions:

Bash:

```bash
source <(coder completion bash)
```

To load completions for each session, execute once: Linux:

```bash
coder completion bash > /etc/bash_completion.d/coder
```

MacOS:

```bash
coder completion bash > /usr/local/etc/bash_completion.d/coder`
```

Zsh:

If shell completion is not already enabled in your workspace you will need to
enable it. You can execute the following once:

```zsh
echo "autoload -U compinit; compinit" >> ~/.zshrc
```

To load completions for each session, execute once:

```zsh
coder completion zsh > "${fpath[1]}/_coder"
```

You will need to start a new shell for this setup to take effect.

Fish:

```fish
coder completion fish | source
```

To load completions for each session, execute once:

```fish
coder completion fish > ~/.config/fish/completions/coder.fish
```

```fish
coder completion [bash|zsh|fish|powershell]
```

### Options

```text
  -h, --help   help for completion
```

### Options inherited from parent commands

```text
  -v, --verbose   show verbose output
```

### SEE ALSO

- [coder](coder.md) - coder provides a CLI for working with an existing Coder
  installation
