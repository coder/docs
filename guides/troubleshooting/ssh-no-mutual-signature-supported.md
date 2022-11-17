---
title: SSH no mutual signature supported
description: Learn how to fix SSH error "no mutual signature supported"
---

When using `coder ssh` to reach your workspace, you may encounter the following
error:

```console
sign_and_send_pubkey: no mutual signature supported
sign_and_send_pubkey: no mutual signature supported
user@coder.workspace: Permission denied (publickey).
```

## Why this happens

Some versions of ssh, including the version that is included in macOS Ventura
(Version 13) fail to select a supported authentication algorithm when connecting
to Coder with an RSA SSH key.  The ssh client incorrectly determines that only
the deprecated `ssh-rsa` algorithm is supported by the server.

## Resolution

### Option 1: Use elliptic curve SSH keys

Elliptic curve key authentication does not appear to suffer the negotiation
failure.  A Coder administrator should configure either `Ed25519` or `ECDSA` SSH
keys under **Manage** > **Admin** > **Security**.

After this configuration change, regenerate your SSH key by clicking your avatar
in the top right, then select **Account** > **SSH keys**, and finally, click the
**Regenerate** button.

Lastly, rebuild your workspace(s) to pick up the new keys.

### Option 2: Configure your SSH client

If you cannot switch to elliptic curve SSH keys, as a workaround, you can
configure your SSH client to use the `ssh-rsa` authentication algorithm.

**NOTE**: Although this algorithm is considered cryptographically insecure,
using it does not alter the overall security properties of `coder ssh` because
all SSH protocol traffic is sent via an authenticated and encrypted tunnel to
your workspace.

Generate SSH configuration entries for your workspaces:

```console
$ coder config-ssh
Your private ssh key was written to "/Users/user/.ssh/coder_enterprise"
An auto-generated ssh config was written to "/Users/user/.ssh/config"
You should now be able to ssh into your workspace
For example, try running

    $ ssh coder.workspace
```

Open your ssh configuration file in a text editor (this is usually at
`~/.ssh/config` but check the output of the previous command if unsure).

For each workspace config block, add the line
`PubkeyAcceptedAlgorithms +ssh-rsa`

For example:

```
SSH Config
Host coder.workspace
    HostName coder.workspace
    ProxyCommand "/opt/homebrew/bin/coder" tunnel --retry 0 workspace 12213 stdio
    StrictHostKeyChecking no
    ConnectTimeout=0
    IdentitiesOnly yes
    IdentityFile="/Users/spike/.ssh/coder_enterprise"
    ControlMaster auto
    ControlPath ~/.ssh/.connection-coder.f6fd39b24f3a813ecc60e43f5063bbcf
    ControlPersist 600
    PubkeyAcceptedAlgorithms +ssh-rsa
```

You will need to repeat this process if you create new workspaces and re-run
`coder config-ssh`

If this doesn't resolve the issue, please
[contact us](https://coder.com/contact) for further support.
