---
title: inotify watcher limit problems
description: Learn how to resolve problems related to the inotify watcher limit.
---

When using some applications and tools, including Webpack or [code-server], you
may encounter an error similar to the following:

> Watchpack Error (watcher): Error: ENOSPC: System limit for number of file
> watchers reached, watch '/some/path'

[code-server]: https://github.com/cdr/code-server

This article will show you how to diagnose and troubleshoot this error, which
relates to an elevated number of inotify watchers in use.

## Background

[`inotify`] allows programs to monitor files for changes, so that they receive
an event whenever a user or program modifies a file. `inotify` requires kernel
resources (memory and processor) for each file it tracks. As a result, the Linux
kernel limits the number of file watchers that each user can register. The
default settings vary according to the host system distribution; on Ubuntu 20.04
LTS, the default limit is 8,192 watches per instance.

[`inotify`]: https://en.wikipedia.org/wiki/Inotify

On a 64-bit system, each `inotify` watch that programs register will consume ~1
kB of kernel memory, which cannot be swapped to disk and is not counted against
the environment memory limit setting.

## Diagnosis

If you encounter the error that's the focus of this article, the total number of
watchers in use is approaching the `max_user_watches` setting. The following
sections will show you how to verify if this is the case.

### Check tunable settings

There are three kernel tuning options related to the `inotify` system:

- `fs.inotify.max_queued_events`: The upper bound on the number of file
  notification events pending delivery to programs
- `fs.inotify.max_user_instances`: The maximum number of `inotify` instances per
  user (programs using `inotify` will typically create a single _instance_, so
  this limit is unlikely to cause issues)
- `fs.inotify.max_user_watches`: The maximum number of files and folders that
  programs can monitor for changes

To see the values for these settings that are applicable to your environment,
run:

```console
$ sysctl fs.inotify.{max_queued_events,max_user_instances,max_user_watches}
fs.inotify.max_queued_events = 16384
fs.inotify.max_user_instances = 128
fs.inotify.max_user_watches = 8192
```

Because these settings are not namespace-aware, the values will be the same
regardless of whether you run the commands on the host system or inside a
container running on that host.

> See [inotify(7)](https://man7.org/linux/man-pages/man7/inotify.7.html) for
> additional details regarding the `inotify` system.

### Identify inotify consumers

To identify the programs consuming `inotify` watches, you can use a script that
summarizes the information available in the `/proc` filesystem, such as
[`inotify-consumers`].

This script will show the names of programs along with the number of `inotify`
watches registered with the kernel:

```console
$ ./inotify-consumers
   INOTIFY
   WATCHER
    COUNT     PID USER     COMMAND
--------------------------------------
     269   254560 coder    /opt/coder/code-server/lib/node /opt/coder/code-server/lib/vscode/out/bootstrap-fork --type=watcherService
       5     1722 coder    /opt/coder/code-server/lib/node /opt/coder/code-server/lib/vscode/out/vs/server/fork
       2   254538 coder    /opt/coder/code-server/lib/node /opt/coder/code-server/lib/vscode/out/bootstrap-fork --type=extensionHost
       2     1507 coder    gpg-agent --homedir /home/coder/.gnupg --use-standard-socket --daemon

     278  WATCHERS TOTAL COUNT
```

> Please note that this is a third-party script published by an individual who
> is not affiliated with Coder, and as such, we cannot provide a warranty or
> support for its usage.

[`inotify-consumers`]:
  https://github.com/fatso83/dotfiles/blob/master/utils/scripts/inotify-consumers

To see the specific files that the tools track for changes, you can use `strace`
to monitor invocations of the `inotify_add_watch` system call:

```console
$ strace --follow-forks --trace='inotify_add_watch' inotifywait --quiet test
inotify_add_watch(3, "test", IN_ACCESS|IN_MODIFY|IN_ATTRIB|IN_CLOSE_WRITE|IN_CLOSE_NOWRITE|IN_OPEN|IN_MOVED_FROM|IN_MOVED_TO|IN_CREATE|IN_DELETE|IN_DELETE_SELF|IN_MOVE_SELF) = 1
```

This example shows that the `inotifywait` command is listening for notifications
related to the `test` file.

## Resolution

If you encounter the file watcher limit, you can do one of two things:

1. Reduce the number of file watcher registrations
1. Increase the maximum file watcher limit

We recommend attempting to reduce the file watcher registrations first, because
increasing the number of file watches may result in high processor utilization.

### Reduce watchers

Many applications include files that change rarely (e.g., third-party
dependencies stored in `node_modules`). Your tools may watch for changes to
these files and folders, consuming `inotify` watchers. These tools typically
provide configuration settings to exclude certain files, paths, and patterns
from file watching.

For example, Visual Studio Code and `code-server` apply the following [user
workspace setting] by default:

```json
"files.watcherExclude": {
  "**/.git/objects/**": true,
  "**/.git/subtree-cache/**": true,
  "**/node_modules/**": true,
  "**/.hg/store/**": true
},
```

Consider adding other infrequently-changed files to this list, which will cause
Visual Studio Code to poll (or check periodically) for changes to those files.

[user workspace setting]: https://code.visualstudio.com/docs/getstarted/settings

For information on how to do this with other software tools, please see their
documentation/user manuals.

### Increase the watch limit

You can increase the kernel tunable option to increase the maximum number of
`inotify` watches for each user. This is a global setting that applies to all
users sharing the same system/Kubernetes node. To do this, modify the `sysctl`
configuration file, or apply a DaemonSet to the Kubernetes cluster to apply that
change to all nodes automatically.

For example, you can create a file called `/etc/sysctl.d/watches.conf` and
include the following contents:

```text
fs.inotify.max_user_watches = 65536
```

Alternatively, you can use the following DaemonSet with `kubectl apply`:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: more-fs-watchers
  namespace: kube-system
  labels:
    app: more-fs-watchers
    k8s-app: more-fs-watchers
spec:
  selector:
    matchLabels:
      k8s-app: more-fs-watchers
  template:
    metadata:
      labels:
        name: more-fs-watchers
        k8s-app: more-fs-watchers
      annotations:
        seccomp.security.alpha.kubernetes.io/defaultProfileName: runtime/default
        apparmor.security.beta.kubernetes.io/defaultProfileName: runtime/default
    spec:
      nodeSelector:
        kubernetes.io/os: linux
      initContainers:
        - name: sysctl
          image: alpine:3
          command:
            - sysctl
            - -w
            - fs.inotify.max_user_watches=16384
          resources:
            requests:
              cpu: 10m
              memory: 1Mi
            limits:
              cpu: 100m
              memory: 5Mi
          securityContext:
            # We need to run as root in a privileged container to modify
            # /proc/sys on the host (for sysctl)
            runAsUser: 0
            privileged: true
            readOnlyRootFilesystem: true
            capabilities:
              drop:
                - ALL
      containers:
        - name: pause
          image: k8s.gcr.io/pause:3.5
          command:
            - /pause
          resources:
            requests:
              cpu: 10m
              memory: 1Mi
            limits:
              cpu: 100m
              memory: 5Mi
          securityContext:
            runAsNonRoot: true
            runAsUser: 65535
            allowPrivilegeEscalation: false
            privileged: false
            readOnlyRootFilesystem: true
            capabilities:
              drop:
                - ALL
      terminationGracePeriodSeconds: 5
```

This DaemonSet will ensure that the corresponding pod runs on _every_ Linux node
in the cluster. When new nodes join the cluster, such as during an autoscaling
event, the DaemonSet will ensure that the pod runs on the new node as well.

You can delete the DaemonSet by running:

```console
$ kubectl delete --namespace=kube-system daemonset more-fs-watchers
daemonset.apps "more-fs-watchers" deleted
```

However, note that the setting will persist until the node restarts or another
program sets the `fs.inotify.max_user_watches` setting.

## See also

- [INotify watch limit](https://blog.passcod.name/2017/jun/25/inotify-watch-limit.html)
  provides additional context on this problem and its resolution
- [inotify(7)](https://man7.org/linux/man-pages/man7/inotify.7.html), the Linux
  manual page related to the `inotify` system call
- [Kernel Korner - Intro to inotify](https://www.linuxjournal.com/article/8478)
- [Filesystem notification, part 1: An overview of dnotify and inotify](https://lwn.net/Articles/604686/)
  and
  [Filesystem notification, part 2: A deeper investigation of inotify](https://lwn.net/Articles/605128/)
  examine the `inotify` mechanism and its predecessor, `dnotify`, in detail
- Microsoft's Language Server Protocol (LSP) specification
  [describes an approach for using file watch notifications](https://microsoft.github.io/language-server-protocol/specification#workspace_didChangeWatchedFiles)
  (Visual Studio Code and code-server, along with many other editors, uses this
  protocol for programming language support, and the same constraints and
  limitations apply to those tools)
- Resources for Visual Studio Code and code-server:
  - [User and Workspace Settings](https://code.visualstudio.com/docs/getstarted/settings),
    in particular, the setting called `files.watcherExclude`
  - [VS Code Setting: files.watcherExclude](https://youtu.be/WMNua0ob6Aw)
    (YouTube)
  - [My ultimate VSCode configuration](https://dev.to/vaidhyanathan93/ulitmate-vscode-configuration-4i2o),
    a blog post describing a user's preferred settings, including file
    exclusions
