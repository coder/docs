---
title: Workspace management
description: See example usages of the CLI for personal workspace management.
---

## List all of your workspaces

```console
$ coder workspaces ls
Name    ImageTag    CPUCores    MemoryGB    DiskGB    GPUs    Updating    Status
cdev    latest      8           12          96        0       false       ON
site    ubuntu      1           1           10        0       false       ON
dev     latest      8           16          64        0       false       OFF
denv    latest      8           16          80        0       false       OFF
```

## Rebuild a workspace

```console
$ coder workspaces rebuild my-workspace --follow
Rebuild workspace "my-workspace"? (will destroy any work outside of /home): y█
✅ -- 2020-12-20T02:43:44Z Deleting old workspace
✅ -- 2020-12-20T02:43:44Z Deleting old network isolation policy
✅ -- 2020-12-20T02:43:44Z Deleting old service
...
```

## Stop all of your workspaces

```console
$ coder workspaces ls -o json | jq -r .[].name | xargs coder workspaces stop
success: successfully stopped workspace "site"
...
```
