---
title: File sync
description: Learn how to sync files between Coder and your local IDE.
---

If you're working in an IDE that's on your local machine, you can use Coder's
live sync feature to sync changes from your local IDE with your Coder
environment. Live sync watches your IDE and pushes updates whenever it detects
changes. This allows you to work locally while leveraging Coder for testing,
compilation, and so on.

## One-way file sync

1. Make sure that you've installed [rsync](https://rsync.samba.org/) on both
   your local machine and Coder environment.

1. To establish a one-way directory sync to a remote environment:

   ```console
   coder sync [local directory] [<env name>:<remote directory>]
   ```

   Include the `-i` or `--init` flag for initial transfer and exit.

### Example

To sync your local directory **~/Projects/cdr/coder-cli** to **coder-cli** in
the home directory of your environment:

```console
$ coder sync ~/Projects/cdr/coder-cli my-env:coder-cli
2020-05-19 17:57:40 INFO doing initial sync (~/Projects/cdr/coder-cli -> coder-cli)
2020-05-19 17:57:41 SUCCESS finished initial sync (878ms)
2020-05-19 17:57:41 INFO watching ~/Projects/cdr/coder-cli for changes
```

## Two-way file sync

Alternatively, you can set up two-way file sync, which allows you to use local
and remote development tools simultaneously. Setting up two-way file sync can
help ensure your project is in the same state no matter where you make changes.

1. Make sure that you've installed
   [Mutagen](https://mutagen.io/documentation/introduction/installation).

1. Log into Coder and configure your local SSH client:

   ```console
   $ coder login https://coder.yourcompany.com
   2020-10-20 11:16:29 SUCCESS Logged in.
   $ coder config-ssh
   An auto-generated ssh config was written to "/Users/yourName/.ssh/config"
   Your private ssh key was written to "/Users/yourName/.ssh/coder_enterprise"
   You should now be able to ssh into your environment
   For example, try running

       $ ssh coder.yourName
   ```

1. Identify your project directory and environment name, then create the sync
   session. Note that the folder must exist on the remote server before you
   begin this step:

   ```console
   $ cd ~/my-project
   $ coder envs ls
   Name     ImageTag    CPUCores    MemoryGB    DiskGB    GPUs    Updating    Status
   yourName latest      4           4           30        0       false       ON
   test     latest      1           1           10        0       false       OFF
   $ mutagen sync create . coder.env-name:~/project
   Created session sync_dLg9zfqynqVa9aj2V36Fr4OCMz1AHzTKzNGFYYkqfAI
   ```

1. Test your connection by running `mutagen sync monitor`. If you're successful,
   your project files should sync on all future changes.

### Pausing or terminating your session

You can pause your sync by running `mutagen sync pause`.

You can stop and delete your session by running `mutagen sync terminate`.
