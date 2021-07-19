---
title: GPG Forwarding
description: Learn how to configure GPG agent forwarding Coder.
---

This guide will show you how to sign, encrypt, and decrypt content using GPG within 
a workspace while the private key stays on your local machine. 

## Local configuration

This guide assumes you already have the capability of using and signing GPG on your 
local machine. The guide examples are from the perspective of a MacOS 11 (Big Sur) 
user so Windows and Linux may require deviation. 

*  Install gnupg using [Homebrew](https://formulae.brew.sh/formula/gnupg) 
   or [gpg-suite](https://gpgtools.org/)
*  Verify that pinentry is installed or install it
*  Create or import your GPG key (both private and public)

```
% gpg --version
gpg (GnuPG) 2.3.1
```


## Coder admin configurations

To use GPG agent forwarding, the Coder instance needs to have two
capabilities enabled: 

1. SSH access to environemnts
2. CVMs (Container-based virtual machines) enabled

[See the SSH docs](../../admin/workspace-management/ssh-access)
for how to configure the sysem to allow SSH connections
and how to send those to OpenSSH.  Without OpenSSH, the basic
libssh server will be used which doesn't support forwarding.

[See the CVM docs](../../admin/workspace-management/cvms) for
configuration details.  Without CVMs enabled, systemd cannot
be run inside the container which prevents OpenSSH from starting.

## Coder image configurations

The dependencies for GPG forwarding include having 

*  openssh-server and gnupg2 installed
*  `StreamLocalBindUnlink yes` set in the /etc/ssh/sshd_config file
*  socket masking
*  enable openssh so that Coder doesn't inject its own

Dockerfile excerpt would look like this

```
FROM ubuntu:20:04
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
    openssh-server \
    gnupg2 \
    systemd \
    systemd-sysv

RUN echo  "StreamLocalBindUnlink yes" >> /etc/ssh/sshd_config && \
    systemctl --global mask gpg-agent.service \
    gpg-agent.socket gpg-agent-ssh.socket \
    gpg-agent-extra.socket gpg-agent-browser.socket && \
    systemctl enable ssh
```

Starting from the [Enterprise Base](https://github.com/cdr/enterprise-images/blob/main/images/base/Dockerfile.ubuntu)
image helps by establishing some dependencies and conventions that
makes using Coder a better experience. If you choose the Enterprise Base
as a starting point, just `apt-get install gnupg2 openssh-server` and then
add the second run block for configuration. 

### Running the image

When you import the image, it does not need any special configurations. 

When creating a new workspace from the image, make sure to select the "CVM"
option.

## Environment-startup configurations (Dotfiles)

The configurations in this section need to be run after the workspace has started
and should be run within the user context. [Coder personalization scripts
(otherwise known as dotfiles)](../../workspaces/personalization.md) are the best
leverage point for these configurations.

To be able to use your local private key on the remote workspace, the workspace
needs to have a reference to the public key and have it be trusted. 

Since some images will have GPG and others won't, we can add this to the 
install.sh script in our dotfiles repo. 

```
if hash gpg 2>/dev/null; then
  echo "gpg found, configuring public key"
  gpg --import ~/dotfiles/.gnupg/mterhar_coder.com-publickey.asc
  echo "16ADA44EDAA5BC7384578654F371232FA31B84AC:6:" | gpg --import-ownertrust
  git config --global user.signingkey F371232FA31B84AC
  echo "export GPG_TTY=\$(tty)" >> ~/.profile
  echo "to enable commit signing, run"
  echo "git config --global commit.gpgsign true"
else
  echo "gpg not found, no git signing"
fi
```

You can see that I've added the public key export directly to the dotfiles
repository so that it will be importable. 

The `gpg --import-ownertrust` command is given the fingerprint of the key
that was just imported with `6` which is "Ultimate" trust level. 

Setting `GPG_TTY` should allow pinentry to send the request for a passphrase
to the correct place. 
