---
title: GPG Forwarding
description: Learn how to configure GPG agent forwarding Coder.
---

This guide will show you how to sign, encrypt, and decrypt content using GPG
within a workspace while the private key stays on your local machine.

## Local configuration

This guide assumes you already have the capability of using and signing GPG on
your local machine. The guide examples are from the perspective of a MacOS 11
(Big Sur) user so Windows and Linux may require deviation.

- Install gnupg using [Homebrew](https://formulae.brew.sh/formula/gnupg) or
  [gpg-suite](https://gpgtools.org/)
- Verify that pinentry is installed or install it
- Create or import your GPG key (both private and public)

```console
gpg --version
gpg (GnuPG) 2.3.1
```

When running any gpg command locally, the system knows to start up the
`gpg-agent` which creates the sockets and performs the cryptographic activity.
If you ssh into an environment using the `-R` flag to remote forward the
sockets, your local gpg-agent won't start automatically since it doesn't invoke
the gpg binary.

The easiest way to address this is to add the gpg-agent to your local .profile,
.bashrc, .zshrc, or whatever terminal configuration scripts always run for each
terminal session.

`gpgconf --launch gpg-agent`

If you don't run this command or `gpg-agent --daemon` to prepare your local
system, sockets won't exist for mounting and the remote gpg command won't work
since it will start an agent in the remote system which has no keys.

## Coder admin configurations

To use GPG agent forwarding, the Coder instance needs to have two capabilities
enabled:

1. SSH access to environemnts
1. CVMs (Container-based virtual machines) enabled

[See the SSH docs](../../admin/workspace-management/ssh-access) for how to
configure the sysem to allow SSH connections and how to send those to OpenSSH.
Without OpenSSH, the basic libssh server will be used which doesn't support
forwarding.

[See the CVM docs](../../admin/workspace-management/cvms) for configuration
details. Without CVMs enabled, systemd cannot be run inside the container which
prevents OpenSSH from starting.

## Coder image configurations

The dependencies for GPG forwarding include having

- openssh-server and gnupg2 installed
- `StreamLocalBindUnlink yes` set in the /etc/ssh/sshd_config file
- socket masking
- enable openssh so that Coder doesn't inject its own

Dockerfile excerpt would look like this

```dockerfile
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

Starting from the
[Enterprise Base](https://github.com/cdr/enterprise-images/blob/main/images/base/Dockerfile.ubuntu)
image helps by establishing some dependencies and conventions that makes using
Coder a better experience. If you choose the Enterprise Base as a starting
point, just `apt-get install gnupg2 openssh-server` and then add the second run
block for configuration.

### Running the image

When you import the image, it does not need any special configurations.

When creating a new workspace from the image, make sure to select the "CVM"
option.

## Environment-startup configurations (Dotfiles)

The configurations in this section need to be run after the workspace has
started and should be run within the user context.
[Coder personalization scripts (otherwise known as dotfiles)](../../workspaces/personalization.md)
are the best leverage point for these configurations.

To be able to use your local private key on the remote workspace, the workspace
needs to have a reference to the public key and have it be trusted.

Since some images will have GPG and others won't, we can add this to the
install.sh script in our dotfiles repo.

```console
if hash gpg 2>/dev/null; then
  echo "gpg found, configuring public key"
  gpg --import ~/dotfiles/.gnupg/mterhar_coder.com-publickey.asc
  echo "16ADA44EDAA5BC7384578654F371232FA31B84AC:6:" | gpg --import-ownertrust
  git config --global user.signingkey F371232FA31B84AC
  echo "pinentry-mode loopback" > ~/.gnupg/gpg.conf
  echo "export GPG_TTY=\$(tty)" > ~/.profile
  echo "to enable commit signing, run"
  echo "git config --global commit.gpgsign true"
else
  echo "gpg not found, no git signing"
fi
```

You can see that I've added the public key export directly to the dotfiles
repository so that it will be importable.

The `gpg --import-ownertrust` command is given the fingerprint of the key that
was just imported with `6` which is "Ultimate" trust level.

The `"pinentry-mode loopback" > ~/.gnupg/gpg.conf` allows the remote system to
trigger pinentry inline where you type your passphrase into the same terminal
that is running the GPG command and it unlocks the mounted socket.

Setting `GPG_TTY` should allow pinentry to send the request for a passphrase to
the correct place. Note that the user of a single `>` prevents that line from
being added to .profile repeatedly, but will erase the contents if you have
anything in that file.

## Making the connection

On your local device, ensure the gpg-agent is running and that it works when you
attempt to perform a GPG action such as `echo "test" | gpg --clearsign".` Since
you'll have entered a pin, the socket will be opene for a bit unless you kill
and restart the agent.

```bash
gpgconf --launch gpg-agent
coder config-ssh
ssh -R /run/user/1000/gnupg/S.gpg-agent:/Users/mterhar/.gnupg/S.gpg-agent coder.<workspace name>
```

After the SSH command, your terminal's prompt should be inside the workspace.
Now that the connection is made from your local filesystem socket to the renote
filesystem socket, GPG actions can commence on the remote side.

```console
$ echo "test " | gpg --clearsign -v
gpg: using character set 'utf-8'
gpg: using pgp trust model
gpg: key F371232FA31B84AC: accepted as trusted key
gpg: writing to stdout
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

test
gpg: EDDSA/SHA256 signature from: "F371232FA31B84AC Mike Terhar <mterhar@coder.com>"
-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQQWraRO2qW8c4RXhlTzcSMvoxuErAUCYPm2fwAKCRDzcSMvoxuE
rHYNAQCrGPbF9Z89dDjemFMtgt0dfsPSUcAlgVj1PKGsg/K8lgEAj8MeTXi1RQhv
dqbC8blPKTAzupH7OeQpe6EbweZHjAI=
=tgC/
-----END PGP SIGNATURE-----
```

If you decide to run a web terminal or use the terminal within code-server, it
will prompt you for the pin and make use of the ssh socket. This is true for
terminals that are running from different devices as well.

### Mitigating the risk

The signing activity only takes a second to complete but the GPG socket remains
open for a few minutes.

### What it looks like

```console
% gpgconf --launch gpg-agent
% ssh -R /run/user/1000/gnupg/S.gpg-agent:/Users/mterhar/.gnupg/S.gpg-agent coder.gpg
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-1039-gke x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
Last login: Thu Jul 22 18:17:57 2021 from 127.0.0.1

$ echo "test " | gpg --clearsign -v
gpg: using character set 'utf-8'
gpg: using pgp trust model
gpg: key F371232FA31B84AC: accepted as trusted key
gpg: writing to stdout
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

test
gpg: EDDSA/SHA256 signature from: "F371232FA31B84AC Mike Terhar <mterhar@coder.com>"
-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQQWraRO2qW8c4RXhlTzcSMvoxuErAUCYPm2fwAKCRDzcSMvoxuE
rHYNAQCrGPbF9Z89dDjemFMtgt0dfsPSUcAlgVj1PKGsg/K8lgEAj8MeTXi1RQhv
dqbC8blPKTAzupH7OeQpe6EbweZHjAI=
=tgC/
-----END PGP SIGNATURE-----
```

Or using it to sign git commits with the terminal:

```console
$ git commit -m "trigger signature"
[gpg-test 2ece8ea] trigger signature
 1 file changed, 2 insertions(+)
$ git verify-commit 2ece8ea
gpg: Signature made Thu Jul 22 19:15:50 2021 UTC
gpg:                using EDDSA key 16ADA44EDAA5BC7384578654F371232FA31B84AC
gpg: Good signature from "Mike Terhar <mterhar@coder.com>" [ultimate]
```

After you push this to GitHub or GitLab, you'll see the "verified" icon beside
the commit.

### Limitations for code-server

The git functionality in code-server will sign the commit and obey the
.gitconfig file however it lacks the ability to ask for a GPG pin so it only
works if the sockt is already open due to some other activity. The git cli in
the snippet above will prompt for to unlock the gpg key.

The error says: "Git: gpg failed to sign the data"

Even if the configuration setting is enabled:

```console
"git.enableCommitSigning": true
```

## Working with a Yubikey or other smart card

The Yubikey configurations required to make GPG work with the local machine
are all that is necessary to use it as a smart card. The pinentry prompt from
the prior examples needs to be given the Yubikey's pin number rather than the
private key passphrase.

As soon as the cryptogrpahic action is complete, removing the Yubikey from the
usb port prevents any additional cryptographic actions from happening through
the GPG forwarding socket.

## Security considerations

Anytime a private key is used, there is some exposure to the systems that are
granted access to the key. The act of typing the passphrase or using
`gpg-preset-passphrase` to keep the socket open each have different risks
(shoulder surfing bystander versus someone accessing the system with open socket
from another terminal).

1. Setting `default-cache-ttl 30` will request the pin more frequently.

1. Connect to the local `.extra` socket rather than the primary which helps
   limit key exposure though it breaks this example.

1. Create a separate subkey for Coder to use to prevent the primary key from
   being compromised if a security incident occurs. This means the subkeys have
   to be added to your Git provider and if there is an incident, the old commits
   may become unverified.

## Errors and what they mean

### Connect to <path to default agent port> -2 failed

```console
connect to /Users/mterhar/.gnupg/S.gpg-agent port -2 failed: No such file or directory
gpg: no running gpg-agent - starting '/usr/bin/gpg-agent'
```

This indicates the socket wasn't present on the local machine when the ssh
command was executed. This could be caused by a lack of `-R` or `ForwardRemote`
in the ssh configuration.

### No secret key

```console
gpg: key F371232FA31B84AC: accepted as trusted key
gpg: no default secret key: No secret key
gpg: [stdin]: clear-sign failed: No secret key
```

This can happen if there is a gpg agent running in the remote workspace which is
intercepting the GPG commands before they get to the remote socket.

Fix with `gpgconf --kill gpg-agent` or by using `ps ax | grep gpg-agent` to find
and kill all the pids. Reconnect your ssh session to re-establish the socket
forwarding.

### Inappropriate ioctl for the device

```console
$ echo "test " | gpg --clearsign -vvv
gpg: using character set 'utf-8'
gpg: using pgp trust model
gpg: key F371232FA31B84AC: accepted as trusted key
gpg: writing to stdout
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

test
gpg: pinentry launched (1744 curses 1.1.1 - xterm-256color - - 501/20 0)
gpg: signing failed: Inappropriate ioctl for device
gpg: [stdin]: clear-sign failed: Inappropriate ioctl for device
```

If `gpg: pinentry launched (1744 curses 1.1.1 - xterm-256color - - 501/20 0)`
does not include the `/dev/pts/1` after the version number, you may need to add
the GPG_TTY environment variable to something that runs prior to trying to run
the command.

If GPG_TTY is set to the same output as `tty` then be sure there is a
`.gnupg/gpg.conf` file which contains `pinentry-mode loopback`.

### SSH troubleshooting

If you receive this error when connecting:

`Warning: remote port forwarding failed for listen path /run/user/1000/gnupg/S.gpg-agent`

The likely cause is that openssh isn't running. This can be because it's not in
the image at all, or `systemctl enable ssh` didn't work. It can also be due to
the workspace not having
[CVM](https://coder.com/docs/coder/v1.20/workspaces/cvms#container-based-virtual-machine-cvm)
enabled.
  
#### After disconnecting the session, signing still works
  
Coder CLI's `coder config-ssh` command uses a session caching which involves:

```plaintext
Host coder.[workspace name]
   [...]
   ControlMaster auto
   ControlPath ~/.ssh/.connection-%r@%h:%p
   ControlPersist 600
```

So the connection will persist after the shell is exited. This makes opening a
new shell very speedy but also keeps the GPG socket forwarding open.
  
#### Generally

Adding `-v` to the SSH command can show when things are happening that don't
typically warrant any output.

### GPG troubleshooting

The sockets don't appear to be where you expect them?

```console
$ gpgconf --list-dirs
sysconfdir:/etc/gnupg
bindir:/usr/bin
libexecdir:/usr/lib/gnupg
libdir:/usr/lib/x86_64-linux-gnu/gnupg
datadir:/usr/share/gnupg
localedir:/usr/share/locale
socketdir:/run/user/1000/gnupg
dirmngr-socket:/run/user/1000/gnupg/S.dirmngr
agent-ssh-socket:/run/user/1000/gnupg/S.gpg-agent.ssh
agent-extra-socket:/run/user/1000/gnupg/S.gpg-agent.extra
agent-browser-socket:/run/user/1000/gnupg/S.gpg-agent.browser
agent-socket:/run/user/1000/gnupg/S.gpg-agent
homedir:/home/coder/.gnupg
```

The output seem too limited and we need more information, add `--verbose` to the
`gpg` command.

### GitHub or GitLab "unverified" commits

Signed commits should have a verification status beside them. If you see
"unverified" it may be that the signing key hasn't been uploaded to the account.

- [GitHub Adding a new GPG key](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account)
- [GitLab Adding a GPG key](https://docs.gitlab.com/ee/user/project/repository/gpg_signed_commits/#adding-a-gpg-key-to-your-account)

It can also be that the email address in the author field doesn't match the
username andsigning key's email.
