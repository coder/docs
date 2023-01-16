# Storage

Coder differentiates between system-installed files and user-installed files.
System-installed files are stored in `/user/`, while user-installed files are
located in the root directory `~`.

Conventionally, Coder places anything installed with `apt` or `yum` or similar
with the system-installed files. This is considered ephemeral storage in Coder
workspaces, and we recommend that you install these using `docker build` and
have them in your image.

Conversely, things installed via `npm`, Java dependencies, Ruby bundles, or
similar, belong in the project folder (which is the `~`) so that it persists in
Coder workspaces.

## Storage allocation for workspaces

Coder allows users to choose how much storage to allocate to their workspace.

Ephemeral storage (where system-installed files are located) is available to
you, but we don't recommend that you use this too often. Kubernetes enforces
some limits on using this storage, and exceeding certain bounds could
potentially lead to eviction in some clusters.

Instead, we recommend installing everything a user needs in the image, including
build steps, so that they can be shared across workspaces. For example, if you
have multiple users start base images and install the same five things
(e.g., Node.js, CLIs, etc.), these things get placed in ephemeral storage, and
none of it is shared across workspaces.

However, if you share some of the items and install them during `docker
build`, the image cache layers have the apps in them, and they can be shared
across workspaces. This also has the benefit of speeding up the workspace build
process.

The only things we recommend placing in your workspace storage are the contents
of your Git repos and any generated artifacts.

If you're using Node.js or Go, you'll see that these install many items in your
persistent user directory to make capabilities like `npx` persist (though these
are project-specific items).
