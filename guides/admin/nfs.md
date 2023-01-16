# NFS file mounting

This guide will walk you through configuring and mounting an NFS file share to a
Coder workspace. The NFS file share will be separate from the user's persistent
volume (represented as `/home/<user>` in the workspace).

## Requirements

To mount an NFS file share, you must use a container-based virtual machine (CVM)
workspace with a FUSE device attached. You can enable both of these features in
the admin panel by navigating to **Manage** > **Admin** > **Infrastructure** >
**Workspace container runtime**.

> Please review
> [the CVM infrastructure requirements before enabling](https://coder.com/docs/coder/latest/admin/workspace-management/cvms)
> CVMs and FUSE devices.

The Coder workspace must have either `nfs-utils` or `nfs-common` installed.

The server must have either `nfs-utils` or `nfs-kernel-server` installed.

Ensure that no firewalls are blocking the client connections. By default, the
NFS daemon is configured to run on a static port of `2049`.

## Server configuration steps

1. Create an NFS mount on the server for the clients to access:

   ```console
   export NFS_MNT_PATH=/mnt/nfs_share
   # Create directory to shaare
   sudo mkdir -p $NFS_MNT_PATH
   # Assign UID & GIDs access
   sudo chown -R uid:gid $NFS_MNT_PATH
   sudo chmod 777 $NFS_MNT_PATH
   ```

1. Grant access to the clients by updating the `/etc/exports` file, which
   controls the directories shared with remote clients. See
   [Red Hat's docs for more information about the configuration options](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/deployment_guide/s1-nfs-server-config-exports).

   ```console
   # Provides read/write access to clients accessing the NFS from any IP address.
   /mnt/nfs_share  *(rw,sync,no_subtree_check)
   ```

1. Export the NFS file share directory. You must do this every time you change
   `/etc/exports`.

   ```console
   sudo exportfs -a
   sudo systemctl restart <nfs-package>
   ```

## Client (Coder workspace) configuration steps

1. Create a directory where the NFS mount will reside:

   ```console
   sudo mkdir -p /mnt/nfs_clientshare
   ```

1. Mount the NFS file share from the server into your workspace:

   ```console
   sudo mount <server-IP>:/mnt/nfs_share /mnt/nfs_clientshare
   ```
