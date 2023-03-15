# Default registry

> This feature is unavailable for air-gapped deployments.

Coder is configured to automatically import the default [registry](index.md),
Docker Hub, to streamline your initial setup process.

This means that your users can create workspaces using Docker Hub images without
further configuration on your part.

## Disable the importing of the default registry

If you prefer a more granular experience, you can disable the importing of
Docker Hub. You'll then have to manually configure registries on a
per-organization basis before you can import images that can be used to create
new workspaces.

To do so:

1. Launch the Coder dashboard.
1. Go to **Manage** > **Admin**.
1. On the **Infrastructure** tab, uncheck the **Import Default Registry**
   option.
1. Click **Save Registry**.

![Import default registry](../../assets/admin/import-default-registry.png)
