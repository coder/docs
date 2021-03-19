---
title: Inotify Watch Limit Increase
description: Learn how to increase the inotify watcher limit.
---

When running a webpack project, you may encounter an error similar to the
following:

```text
Watchpack Error (watcher): Error: ENOSPC: System limit for number of file
watchers reached, watch '/some/path'
```

This results from a low number of [inotify
watches](https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit)
combined with high node usage, causing the log stream to fail.

## Resolution

Increase the number of file watchers. Because the setting quantifying the number
of file watchers isn't namespaced, you'll need to raise the maximum number at
the node level.

One way to do this is to use a daemonset in the cluster with a privileged container to set the
maximum number of file watchers (H/T:
[xinyanmsft](https://github.com/Azure/AKS/issues/772#issuecomment-477760184)):

```yaml
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: more-fs-watchers
  namespace: kube-system
  labels:
    app: more-fs-watchers
spec:
  template:
    metadata:
      labels:
        name: more-fs-watchers
    spec:
      hostNetwork: true
      hostPID: true
      hostIPC: true
      initContainers:
        - command:
            - sh
            - -c
            - sysctl -w fs.inotify.max_user_watches=524288;
          image: alpine:3.6
          imagePullPolicy: IfNotPresent
          name: sysctl
          resources: {}
          securityContext:
            privileged: true
          volumeMounts:
            - name: sys
              mountPath: /sys
      containers:
        - resources:
            requests:
              cpu: 0.01
          image: alpine:3.6
          name: sleepforever
          command: ["tail"]
          args: ["-f", "/dev/null"]
      volumes:
        - name: sys
          hostPath:
            path: /sys
```

For Kubernetes v1.18:

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
    spec:
      hostNetwork: true
      hostPID: true
      hostIPC: true
      initContainers:
        - command:
            - sh
            - -c
            - sysctl -w fs.inotify.max_user_watches=524288;
          image: alpine:3.6
          imagePullPolicy: IfNotPresent
          name: sysctl
          resources: {}
          securityContext:
            privileged: true
          volumeMounts:
            - name: sys
              mountPath: /sys
      containers:
        - resources:
            requests:
              cpu: 0.01
          image: alpine:3.6
          name: sleepforever
          command: ["tail"]
          args: ["-f", "/dev/null"]
      volumes:
        - name: sys
          hostPath:
            path: /sys
```

## Notes

- Daemonsets without node selectors will persist on the cluster and will run on
  *every* node. Every new node that you spin up will also have an associated
  daemonset pod spun up to ensure that the sysctl command runs on every node.
- You can **delete** this by running:

    ```console
    kubectl delete more-fs-watchers
    ```

    This command removes all related daemonset pods, and no further pods will be
    spun up.

## Helpful Resources

- [Setting Sysctls for a
  Pod](https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/#setting-sysctls-for-a-pod)
- [Increasing the Amount of `inotify`
  Watchers](https://github.com/guard/listen/blob/master/README.md#increasing-the-amount-of-inotify-watchers)
