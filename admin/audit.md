---
title: "Audit"
description: Learn how Coder audits user and admin actions.
---

Coder maintains records of all user actions on system resources for auditing
purposes.

Any user who is a **Site Manager** or an **Auditor** can log into Coder, go to
**Manage** > **Audit**, and view the **Audit Logs**.

By default, this page displays a chronological list of all actions taken on the
system.

![Audit logs](../assets/admin/audit-log.png)

You can filter the logs displayed using the search filters available at the top:

- **Resource Type**: The resource on which the action is taken (e.g., image,
  workspace, user)
- **Action**: The action that the user took against a resource (e.g., read,
  write, create)
- **Resource Target**: The friendly name for the resource (e.g., the user with
  the email address **dev@coder.com**)
- **User**: The user who performs the action

## Actions

The audit logs capture information about the following actions (those who
[export Coder logs](../guides/admin/logging.md) will see this information under
`message.fields.audit_log.action`):

When reviewing Coder's audit logs, specifically, you will see the following
actions included:

- `auto_off`: Coder automatically turned off a workspace due to inactivity
- `auto_start`: Coder automatically turned on a workspace at the time preset by
  its owner
- `connect`: a user connected to an existing workspace via a local VS Code
  instance, a JetBrains IDE via JetBrains Gateway, a local terminal `ssh`
  connection, or a local terminal connection via the Coder CLI's `coder ssh`
  command
- `cordon`: a workspace provider became unavailable for new workspace creation
  requests
- `create`: the user created a Coder entity (e.g., dev URL, image/image tag,
  workspace, etc.)
- `delete`: a user deleted a Coder entity (e.g., workspace or image)
- `enqueue`: a user added a new job to the queue (e.g., workspace build, user
  deletion, workspace deletion)
- `login`: a user logs in via basic authentication or OIDC, with Coder
  exchanging a token as a result
- `open`: a user opened a workspace using the Code Web IDE through the browser
  (please note that this action is not yet logged for JetBrains IDEs)
- `ssh`: a user opened a web terminal to access Coder
- `stop`: a user manually stopped a workspace
- `uncordon`: a workspace provider became available for new workspace creation
  requests
- `view`: the Coder CLI used a secret
- `write`: the user made a change to a Coder entity (e.g., workspace, user,
  resource pool, etc.)

## Admin logged events

With the exception of a few, logged events made by Admin panel changes will output
the changed field(s) and the new, corresponding value. Below is the expected
(example) output for each Admin panel change:

### Infrastructure

 **Admin Setting** | **Action** | **Target** | **Field** | **Diff**
------|------|------|------|------
Access URL | Write  | infrastructure | access URL | `coder.com`
GPU Vendor | Write  | infrastructure | gpu vendor | `amd/nvidia/none`
Enable container-based virtual machines | Write | infrastructure | enable container vms| `true/false`
Enable caching | Write | infrastructure | enabled cached container vms | `true/false`
Enable auto loading of `shiftfs` kernel module | Write | infrastructure | enable load shiftfs | `true/false`
Default to container-based virtual machines | Write | infrastructure | default container vms | `true/false`
Enable self-contained workspace builds | Write | features | coder agent pull assets | `enabled/disabled`
Enable workspace process logging | Write | features | exectrace | `enabled/disabled`
Enable TUN device | Write | features | fuse device | `enabled/disabled`
Enable FUSE device | Write | features | tun device | `enabled/disabled`
Enable default registry | Write | infrastructure | default registry enabled | `true/false`
Enable ECR IAM role authentication | Write |features | ecr auth irsa | `enabled/disabled`
Enable AAD authentication for ACR | Write | features | azure auth aad | `enabled/disabled`
Enable fallback shell support for K8s | Write | features | |
Extension marketplace type | Write | * | ext marketplace type | `public/custom`
Dev URL access permissions | Write | devurl access | public/org/authed/ | `true/false`
Enable memory overprovisioning | Write | infrastructure | memory overprovisioning enabled | `true/false`

### Git OAuth

| **Admin Setting** | **Action** | **Target** | **Field** | **Diff** |
|------|------|------|------|------|
| Client ID | Write | oauth configs | client id| `0fb2...7a4a` |
| Client Secret | Write | oauth configs | client secret | `******` |
| Description | Write | oauth configs | description | `example` |
|Name | Write | oauth configs | name | `GitHub` |
| Provider |Write | oauth configs |service type | `github/gitlab` |
| URL | Write| oauth configs | URL host | `host.com`

### Appearance

| **Admin Setting** | **Action** | **Target** | **Field** | **Diff** |
|------|------|------|------|------|
| System Banner | Write | system banner | enabled | `true/false` |
| Background color | Write | system banner | color bg | `#9A4967` |
| Footer | Write | system banner | text footer | `UNCLASSIFIED` |
| Header | Write | system banner | text header | `UNCLASSIFIED` |
| Service Banner | Write | appearance | svc banner enabled | `true/false` |
| Background color | Write | appearance | svc banner color bg | `#18382D` |
| Message | Write | appearance | svc banner body | `Maintenance 9:01PM` |
| Terms of Service | Write | appearance | tos body | `Accept Terms & Conditions` |
| Text field | Write | appearance | tos enabled | `true/false` |

### Telemetry

| **Admin Setting** | **Action** | **Target** | **Field** | **Diff** |
|------|------|------|------|------|
| Send crash reports | Write | telemetry | crash reports enabled | `true/false` |
| Send usage telemetry | Write | telemetry | enhanced telemetry enabled| `true/false` |
| Send enhanced usage telemetry | Write | telemetry | telemetry enabled | `true/false` |

### Templates

> The template policy dropdown will provide a unique `commit`/`hash` for the
> uploaded file. If file is uploaded from disk, then `file path`/`git ref` will
> be `local`.

| **Admin Setting** | **Action** | **Target** | **Field** | **Diff** |
|------|------|------|------|------|
| Enable workspace templates | Write | infrastructure | enable workspaces as code | `true/false` |
| Template policy | Write | local | commit/file hash/filepath/git ref/From | `0000...0000`/`ed19...843b`/`local`/`local`/`User`|
