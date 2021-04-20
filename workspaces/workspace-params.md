---
title: Workspace parameters
description: Learn about each parameter available during workspace creation.
---

Whenever you log into Coder, you'll see the **Workspace** page.

If this is your first time using Coder, you'll see a **Create Workspace** button
in the middle of your screen; otherwise, you'll see a list of your existing
workspaces.

To create a workspace, launch the creation dialog by:

- Clicking **Create Workspace** (if available), or
- Clicking **New Workspace** in the top-right

![Create a workspace](../assets/create-workspace.png)

When prompted, provide the following information:

<table>
    <tr>
        <td><b>Workspace name</b></td>
        <td>A friendly name for your workspace</td>
    </tr>
    <tr>
        <td><b>Image source</b></td>
        <td>The source of your image; leave as <b>Existing</b> in most cases.
        You can also <b>import</b> a new image if your site manager has imported
            a <a href="../admin/registries/index.md">registry</a> or select a <b><a
            href="https://github.com/cdr/enterprise-images">packaged</
            a></b> image provided by Coder if your site manager has
            enabled the automatic importing of the <a
            href="../admin/registries/default-registry.md">Default Registry</a>.
        </td>
    </tr>
    <tr>
        <td><b>Image</b></td>
        <td>The Docker image you want to use as the base for your workspace</td>
    </tr>
    <tr>
        <td><b>Tag</b></td>
        <td>The version of the image you want to use</td>
    </tr>
    <tr>
        <td><b>Workspace provider</b></td>
        <td>The Kubernetes cluster to which your workspace will be deployed.
        Default: <code>built-in</code></td>
    </tr>
        <tr>
        <td><b>Autostart</b></td>
        <td>Whether you want your workspace to turn on automatically at a
        specific time (you can set the autostart time in User Preferences.</td>
    </tr>
</table>

Coder offers several **advanced** settings that allow you to customize your
workspace. You can choose to run your workspace as a container-based virtual
machine, provide a dotfiles URI for [personalization](personalization.md), and
set your resource allocation.

![Workspace setup advanced settings](../assets/advanced-workspace-config.png)

<table>
    <tr>
        <td><b>Run as container-based virtual machine</b></td>
        <td>Enable this to allow the running of system-level applications like
        Docker, Systemd, and Kubernetes; this provides a VM-like experience with
        the footprint of a container</td>
    </tr>
    <tr>
        <td><b>Dotfiles Git URI</b></td>
        <td>The link to your Dotfiles repo; Coder will apply the settings
        prescribed every time your workspace rebuilds</td>
    </tr>
    <tr>
        <td><b>CPU cores</b></td>
        <td>The number of CPU cores you'd like for your workspace</td>
    </tr>
    <tr>
        <td><b>Memory</b></td>
        <td>The amount of memory you'd like for your workspace</td>
    </tr>
    <tr>
        <td><b>Disk</b></td>
        <td>The amount of storage space you'd like for your workspace</td>
    </tr>
    <tr>
        <td><b>GPU</b></td>
        <td>The number of
        <a href="../admin/workspace-management/gpu-acceleration.md">GPUs</a>
        you want allocated to your workspace</td>
    </tr>
</table>

> By default, Coder allocates resources (CPU cores, memory, and disk space)
> based on the parent image.
>
> Coder displays a warning if you choose your resource settings and they're less
> than the image-recommended default, but you can still create the workspace.

When done, click **Create** to proceed. Coder redirects you to an overview page
for your workspace during the build process.

## .gitconfig files

If the image you're using to create your workspace doesn't include a .gitconfig
file, Coder will generate one for you automatically using the details found in
your Coder account.

You can modify the .gitconfig file, but we recommend using a
[personalization](personalization.md) file to customize your workspace.
