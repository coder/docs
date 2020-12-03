You can access the shell of your Coder environment from your computer using the
CLI's `coder sh` command.

## Usage

```shell
coder sh <env name> [<command [args...]>]
```

This executes a remote command on the environment; if no command is specified,
the CLI opens up the environment's default shell.

For example, you can print "Hello World" in your Coder environment shell as
follows:

```shell
coder sh my-env echo "hello world"
hello world
```
