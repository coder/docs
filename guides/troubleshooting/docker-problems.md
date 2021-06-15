---
title: Docker key storage issues
description: Learn how to solve Docker key storage issues inside Coder workspaces.
---

When using Coder, you may encounter the following error:

```console
docker: Error response from daemon: OCI runtime create failed:
container_linux.go:370: starting container process caused:
process_linux.go:459: container init caused: join session keyring:
create session key: disk quota exceeded: unknown.
```

## Why this happens

The kernel allocates a system key for each container created. When lots of
developers are sharing the same instance, you may run into limits on the number
and size of keys each user can have.

## Resolution

To fix this error, you can increase `maxkeys` and `maxbytes`. These are global
settings that apply to *all* users sharing the same system. You can modify this
by adding the following to the `sysctl` configuration file:

```console
sudo sysctl -w kernel.keys.maxkeys=20000
sudo sysctl -w kernel.keys.maxbytes=400000
```

Alternatively, you can use a DaemonSet with `kubectl apply` to make changes to
`sysctl`:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: increase-limits
  namespace: kube-system
  labels:
    app: increase-limits
    k8s-app: increase-limits
spec:
  selector:
    matchLabels:
      k8s-app: increase-limits
  template:
    metadata:
      labels:
        name: increase-limits
        k8s-app: increase-limits
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
            - kernel.keys.maxkeys=20000
            - kernel.keys.maxbytes=400000
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

At a later point, you can delete the DaemonSet by running:

```console
$ kubectl delete --namespace=kube-system daemonset increase-limits
daemonset.apps "increase-limits" deleted
```

However, note that the setting will persist until the node restarts or another
program sets the `kernel.keys.maxkeys` and `kernel.keys.maxkeys` settings.
