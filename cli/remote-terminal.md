---
title: "Remote terminal"
description: Learn how to use the Coder CLI to access your workspace.
---

You can access the shell of your Coder workspace from your local computer using
the `coder ssh` command.

## Usage

```console
coder ssh <workspace name> [<command [args...]>]
```

This executes a remote command on the workspace; if no command is specified, the
CLI opens up the workspace's default shell.

For example, you can print "Hello World" in your Coder workspace shell as
follows:

```console
$ coder ssh my-workspace echo "hello world"
hello world
```
