---
title: NFS File Mounting
description: Learn how to mount NFS file shares onto Coder workspaces
---

This guide will walk you through how to configure and mount an NFS file share to
a Coder workspace. The NFS file share will be a separate mount from the user's
persistent volume, represented as `/home/<user>` in the workspace.

## Requirements

To mount an NFS file share, you must use a Container-based Virtual Machine (CVM)
workspace with a FUSE device attached. You can enable both of these features in
the Admin panel by navigating to **Manage** > **Admin** > **Infrastructure** >
**Workspace container runtime**.
[Please review the CVM infrastructure requirements prior to enabling](https://coder.com/docs/coder/latest/admin/workspace-management/cvms).

In your Coder workspace, you must install either `nfs-utils` or `nfs-common`
installed. The server must have either `nfs-utils` or `nfs-kernel-server`
installed.

Ensure no firewalls block the client connections. By default, the NFS daemon is
configured to run on a static port of `2049`.

## Server steps

1. Create an NFS mount on the server for clients to access:

    ```console
    export NFS_MNT_PATH=/mnt/nfs_share
    # Create directory to shaare
    sudo mkdir -p $NFS_MNT_PATH
    # Assign UID & GIDs access
    sudo chown -R uid:gid $NFS_MNT_PATH
    sudo chmod 777 $NFS_MNT_PATH
    ```

1. Grant clients access by updating the `/etc/exports` file. This controls which
   directories are shared with remote clients.
   [See here for more information on the configuration options](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/deployment_guide/s1-nfs-server-config-exports).

    ```console
    # Provides read/write access to clients accessing the NFS from any IP address.
    /mnt/nfs_share  *(rw,sync,no_subtree_check)
    ```

1. Export the NFS file share directory. This must be done every time
   `/etc/exports` is changed.

   ```console
   sudo exportfs -a
   sudo systemctl restart <nfs-package>
   ```

## Client steps (Coder workspace)

1. Create a directory where the NFS mount will reside:

    ```console
    sudo mkdir -p /mnt/nfs_clientshare
    ```

1. Mount the NFS file share from the server into your workspace:

    ```console
    sudo mount <server-IP>:/mnt/nfs_share /mnt/nfs_clientshare
    ```
