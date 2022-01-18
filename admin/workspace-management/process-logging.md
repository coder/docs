---
title: "Workspace process logging"
description:
  "Learn how to enable workspace process logging for your deployment."
---

Coder allows administrators to enable workspace process logging for all
workspaces on the platform. Enabling this feature will add a sidecar to all
Kubernetes-based workspaces that will log all processes that are started in the
workspaace, such as commands executed in a terminal or processes created by
background services in CVMs.

[eBPF][ebpf] is used to perform fast in-kernel logging and filtering of all
`exec` syscalls to match events originating only from within the workspace. We
chose eBPF over other solutions due to its higher speed than other solutions.

## Considerations

- This feature is only supported on Kubernetes workspaces. All other workspace
  types (such as [EC2][ec2-doc] or [Coder for Docker][c4d-doc] workspaces) will
  still function correctly but will not include process logging capabilities.
- Workspace process logging requires all nodes that workspaces can be scheduled
  on across all workspace providers run a Linux kernel >= 5.8. If this
  requirement is not met, workspaces scheduled on incompatible nodes will fail
  to start correctly for security purposes.
  - Google Kubernetes Engine (GKE) stable branch kernels are currently 5.4 which
    means this feature currently does not work on GKE, but you may have luck on
    the rapid branch.
  - AWS Elastic Kubernetes Service (EKS) kernels on the Ubuntu 20.04 image
    family have a supported kernel version. Other image families are untested.
- The sidecar attached to each workspace is a [privileged][privileged] container
  (similarly to the CVM container on CVM-enabled workspaces), so some
  consideration may be needed based on your organization's security policies
  before enabling this feature. Enabling this feature does not grant extra
  privileges to the workspace container itself, however.
- Processes from nested Docker containers (including deeply nested containers)
  are logged correctly, but there is currently no distinction between processes
  started in the workspace directly or in a child container in the outputted
  logs.
- On CVMs, this feature may log extra startup processes started in the "outer
  container", which will include container initialization processes.
- Since this logs all processes in the workspace, high amounts of process usage
  (i.e. during a `make` run) will cause lots of output in the sidecar container.
  Depending on how your Kubernetes cluster is configured, you may be charged
  extra by your cloud provider to store these additional logs.

## Usage

You can toggle this feature on or off by going to **Manage** > **Admin** >
**Infrastructure**, then scrolling down to **Workspace container runtime** and
toggling **Enable workspace process logging**. Once changed, click **Save
workspaces** to persist the new setting.

This setting will apply to all new workspaces and will only apply to existing
workspaces after they have been rebuilt.

![Configuring workspace process logging](../../assets/admin/process-logging.png)

To view the process logs from a specific user or workspace, you can use your
cloud's log viewer or use `kubectl` directly like so:

```bash
kubectl logs \
  -l "com.coder.username=zac" \        # Filter by the user "zac"
  -l "com.coder.workspace.name=code" \ # Filter by the workspace "code"
  -c exectrace                         # Only show logs from the sidecar
```

[ec2-doc]: ../workspace-providers/deployment/ec2.md
[c4d-doc]: ../../setup/docker.md
[ebpf]: https://ebpf.io
[privileged]:
  https://kubernetes.io/docs/concepts/policy/pod-security-policy/#privileged
