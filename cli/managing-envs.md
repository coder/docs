---
title: Environment management
description:
  See example usages of the CLI for personal environment management.
---

## List all of your Environments

```plaintext
coder envs ls
Name    ImageTag    CPUCores    MemoryGB    DiskGB    GPUs    Updating    Status
cdev    latest      8           12          96        0       false       ON
site    ubuntu      1           1           10        0       false       ON
dev     latest      8           16          64        0       false       OFF
denv    latest      8           16          80        0       false       OFF
```

## Rebuild an Environment

```plaintext
coder envs rebuild my-env --follow
Rebuild environment "my-env"? (will destroy any work outside of /home): y█
✅ -- 2020-12-20T02:43:44Z Deleting old environment
✅ -- 2020-12-20T02:43:44Z Deleting old network isolation policy
✅ -- 2020-12-20T02:43:44Z Deleting old service
...
```

## Stop all of your Environments

```plaintext
coder envs ls -o json | jq -r .[].name | xargs coder envs stop
success: successfully stopped environment "site"
...
```

## Full Reference

For a full list of the Coder CLI commands available, see the
[reference pages](https://github.com/cdr/coder-cli/blob/master/docs/coder.md).
