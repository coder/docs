---
title: GPG forwarding
description: Learn how to configure GPG agent forwarding Coder.
---

This guide will show you how to sign, encrypt, and decrypt content where GPG is
in a Coder workspace while the private key is on your local machine.

## Step 1: Configure your local machine

We assume that you're already capable of using and signing GPG on your local
machine.

The examples in this guide were created using macOS 11 (Big Sur); Windows and
Linux users may need to modify the provided instructions.

First, make sure that you've:

- Installed GnuPG (GPG) using [Homebrew](https://formulae.brew.sh/formula/gnupg)
  or [gpg-suite](https://gpgtools.org/)
- Verified that `pinentry` is installed (if not, install `pinentry`)
- Created or imported both your public and private GPG keys

You can verify your GnuPG installation and version number as follows:

```console
gpg --version
gpg (GnuPG) 2.3.1
```

### Starting GnuPG

When running any `gpg` command, your system knows to start `gpg-agent`, which
creates the sockets needed and performs the cryptographic activity. However, if
you connect to a workspace via SSH using the `-R` flag to remote forward the
sockets, your local `gpg-agent` won't start automatically since this process
doesn't invoke the `gpg` binary.

To address this issue, add the gpg-agent to your local `.profile`, `.bashrc`,
`.zshrc`, or configuration script that runs for each terminal session:

```console
gpgconf --launch gpg-agent
```

Alternatively, you can run `gpg-agent --daemon` to prepare your local system.

If you don't perform either of the steps above, there won't be sockets for
mounting and the remote `gpg` command won't work (instead, you'll end up
starting an agent in the remote system that has no keys).

## Step 2: Configure Coder

> The following steps must be performed by a Coder user assigned the **site
> manager** role.

To use GPG agent forwarding, ensure that you've enabled:

- [SSH access to workspaces](../../admin/workspace-management/ssh-access.md);
  you must use OpenSSH (the basic `libssh` server doesn't support forwarding)
- [Container-based virtual machines (CVMs)](../../admin/workspace-management/cvms.md);
  CVMs are required to run `systemd`, which is required for OpenSSH to start

## Step 3: Configure a Coder image to support GPG forwarding

Update the image on which your workspace is based to include the following
dependencies for GPG forwarding:

- `openssh-server` and `gnupg2` installed
- `StreamLocalBindUnlink yes` set in the `/etc/ssh/sshd_config` file
- Socket masking
- `OpenSSH` enabled (so that Coder doesn't inject its own ssh daemon)

Your updated Dockerfile would look something like:

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

Alternatively, you can create a new image from scratch. If so, we recommend
starting with Coder's
[Enterprise Base](https://github.com/cdr/enterprise-images/blob/main/images/base/Dockerfile.ubuntu)
image, which helps establish dependencies and conventions that improves the
Coder user experience.

If you use the Enterprise Base image as your starting point:

1. run `apt-get install gnupg2 openssh-server`
1. Add the following to the Dockerfile:

   ```dockerfile
   RUN echo  "StreamLocalBindUnlink yes" >> /etc/ssh/sshd_config && \
       systemctl --global mask gpg-agent.service \
       gpg-agent.socket gpg-agent-ssh.socket \
       gpg-agent-extra.socket gpg-agent-browser.socket && \
       systemctl enable ssh
   ```

## Step 4: Create/update a workspace using the image

Once you've created your image, you can [import it](../../images/importing.md)
for use. When creating a workspace using that image, be sure to
[create a CVM-enabled workspace](../../workspaces/getting-started.md).

## Step 5: Define the workspace-startup configurations using dotfiles

The configuration detailed in this section must be be run _after_ you've created
and started your workspace (the configurations must be run within the context of
your user). We recommend defining your configuration using
[Coder personalization scripts (otherwise known as dotfiles)](../../workspaces/personalization.md#dotfiles-repo).

To use your local private key on the remote Coder workspace, you must provide
the workspace a reference to the public key and the key must be trusted. You
must also account for the fact that not all images will include GPG. To do both,
add the following to an `install.sh` script, then add the file to your dotfiles
repo:

```sh
if hash gpg 2>/dev/null; then
  echo "gpg found, configuring public key"
  gpg --import ~/dotfiles/.gnupg/mterhar_coder.com-publickey.asc
  echo "16AD...B84AC:6:" | gpg --import-ownertrust
  git config --global user.signingkey F371232FA31B84AC
  echo "pinentry-mode loopback" > ~/.gnupg/gpg.conf
  echo "export GPG_TTY=\$(tty)" > ~/.profile
  echo "to enable commit signing, run"
  echo "git config --global commit.gpgsign true"
else
  echo "gpg not found, no git signing"
fi
```

**Notes regarding the sample script:**

- Adding the public key export directly to the dotfiles repository (as shown in
  the example) allows it to be imported.
- The `gpg --import-ownertrust` command gets the fingerprint of the key that was
  just imported with a trust level of `6` (this indicates a trust level of
  **ultimate**).
- The `"pinentry-mode loopback" > ~/.gnupg/gpg.conf` allows the remote system to
  trigger `pinentry` inline so that you can type your passphrase into the same
  terminal where you're running the GPG command to unlock the mounted socket.
- Setting `GPG_TTY` allows `pinentry` time to send the request for a passphrase
  to the correct place. The use of a single `>` prevents that line from being
  added to `.profile` repeatedly, though anything you have in the file will be
  erased.

## Step 6: Connect to Coder

On your local machine, ensure that `gpg-agent` is running and that it works when
you attempt to perform a GPG action (e.g., `echo "test" | gpg --clearsign`).
Note that you'll be prompted to provide your pin; as such, the socket will be
open for a bit unless you kill and restart the GPG agent.

To launch `gpg-agent` and connect to Coder:

```bash
gpgconf --launch gpg-agent
coder config-ssh
ssh -R /run/user/1000/gnupg/S.gpg-agent:/Users/mterhar/.gnupg/S.gpg-agent coder.<workspace name>
```

At this point, there is a connection from your local filesystem socket to the
remote filesystem socket, so you can begin running GPG actions:

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

If you decide to run a web terminal or use the terminal within code-server,
you'll be prompted for to enter your pin and to use the SSH socket (this is true
for terminals that are running from different devices as well).

### Example: GPG forwarding action

The following is an example of what a GPG forwarding action looks like:

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

To sign Git commits via the command line:

```console
$ git commit -m "trigger signature"
[gpg-test 2ece8ea] trigger signature
 1 file changed, 2 insertions(+)
$ git verify-commit 2ece8ea
gpg: Signature made Thu Jul 22 19:15:50 2021 UTC
gpg:                using EDDSA key 16ADA44EDAA5BC7384578654F371232FA31B84AC
gpg: Good signature from "Mike Terhar <mterhar@coder.com>" [ultimate]
```

Now, when you push commits to GitHub/GitLab, you'll see that the commits are
flagged as verified.

## Using a Yubikey or other smart card

The Yubikey configurations required to make GPG work with the local machine are
all that is necessary to use it as a smart card.

Once you've configured Yibikey, you can follow the steps detailed in this
article to set up GPG forwarding; the only difference is that you should provide
`pinentry` with your Yubikey PIN, not the private key passphrase.

As soon as the cryptographic action is complete, be sure remove the Yubikey from
the USB port to prevent any additional cryptographic actions from occurring
through the GPG forwarding socket.

## Limitations for code-server users

The Git functionality in code-server will sign the commit and obey the
`.gitconfig` file. However, it lacks the ability to ask for a GPG pin, so the
forwarding process only works if the socket is already open due to some other
activity. For example, the following Git CLI command would typically prompt you
to unlock the GPG key:

```text
git verify-commit <commit>
```

However, if the socket isn't already open, you'd get an error saying
`Git: gpg failed to sign the data`, even if the configuration setting is
enabled:

```console
"git.enableCommitSigning": true
```

## Security considerations

Any time you use a private key, you expose it to the systems that are granted
access to the key.

Furthermore, actions such as typing the passphrase or using
`gpg-preset-passphrase` to keep the socket open each have different risk
profiles associated (e.g., the risk of someone looking over your shoulder and
the risk of someone accessing the system with open socket from another
terminal).

The following are steps you can take to minimize your risk:

1. Setting `default-cache-ttl 30`, which will prompt you for your PIN more
   frequently. While the signing activity only takes a short amount of time to
   complete, the GPG socket remains open longer.

1. Connect to the local `.extra` socket rather than the primary socket, which
   helps limit key exposure (if you do this, modify examples in this article to
   use the appropriate socket).

1. Create a separate sub-key for Coder to use to prevent the primary key from
   being compromised if a security incident occurs. You'll need to add the
   sub-keys to your Git provider, and if there's a security incident, the old
   commits signed using the affected keys may be considered unverified.

1. As of Coder 1.22, `coder config-ssh` enables the ControlMaster mechanism which
   caches connections even after the interactive shell is exited. This means GPG actions
   on the remote system can take place when there is no apparent connection. To disable
   this mechanism on your GPG forwarded ssh connection, add the command line options:
   `-o ControlMaster=no -o ControlPath=none`

## Troubleshooting

The following sections explain how you can troubleshoot errors you may see when
using up GPG forwarding.

### Unable to connect to the default agent port

```console
connect to /Users/mterhar/.gnupg/S.gpg-agent port -2 failed: No such file or directory
gpg: no running gpg-agent - starting '/usr/bin/gpg-agent'
```

If you see this error, the socket wasn't present on the local machine when you
executed your `ssh` command. This is caused by a lack of `-R` or `ForwardRemote`
in the `ssh` configuration, so update your configuration accordingly.

### No secret key

```console
gpg: key F371232FA31B84AC: accepted as trusted key
gpg: no default secret key: No secret key
gpg: [stdin]: clear-sign failed: No secret key
```

This error can happen if there's a `gpg` agent running in the remote workspace
that is intercepting the GPG commands _before_ they get to the remote socket.

You can fix this by:

1. Running `gpgconf --kill gpg-agent`
1. Using `ps ax | grep gpg-agent` to find and kill all of the pids.

Then, reconnect your `ssh` session to re-establish the socket forwarding.

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
the `GPG_TTY` environment variable to a process that runs before trying to use
`gpg`.

If `GPG_TTY` is set to the same output as `tty`, be sure you have a
`.gnupg/gpg.conf` file that contains `pinentry-mode loopback`.

### SSH error with remote port forwarding

If you receive this error when connecting via SSH:

```console
Warning: remote port forwarding failed for listen path
/run/user/1000/gnupg/S.gpg-agent
```

The likely cause is that `openssh` isn't running. This could be a result of:

- The image you're using doesn't include `openssh`
- The `systemctl enable ssh` command didn't work
- The workspace doesn't have
  [CVMs](https://coder.com/docs/coder/v1.20/workspaces/cvms#container-based-virtual-machine-cvm)
  enabled.

### Unverified commits in GitHub or GitLab

Both GitHub and GitLab display verification statuses beside signed commits. If
you see a commit that's unverified, it could be that the signing key hasn't been
uploaded to the associated account.

To fix this issue, add the GPG key to your account:

- [GitHub: Adding a GPG key](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account)
- [GitLab: Adding a GPG key](https://docs.gitlab.com/ee/user/project/repository/gpg_signed_commits/#adding-a-gpg-key-to-your-account)

If this doesn't fix the issue, ensure that the email address in the author field
matches the email associated with the username and signing key.

### The signing still works after disconnecting the session

Coder CLI's `coder config-ssh` command uses session caching:

```plaintext
Host coder.[workspace name]
   [...]
   ControlMaster auto
   ControlPath ~/.ssh/.connection-%r@%h:%p
   ControlPersist 600
```

Therefore, the connection persists for some time and the GPG socket forwarding
remains open to make opening a new shell fast.

### Verbose logging

If you're having issues with GPG forwarding, getting verbose logs is helpful for
pinpointing where the issue may be. One way to do so is to add `-v` to the SSH
command you run.

You can also add `--verbose` to the `gpg` command. For example, if your sockets
aren't where you expected them and you receive the following output, you'll need
to get additional information via verbose logs:

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
