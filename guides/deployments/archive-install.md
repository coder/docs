# Coder installation from an archive

You can install Coder from an archive instead of using Helm. To do so, replace
**steps 1-2** of the [Installation guide](../../setup/installation.md) with the
following three steps, then proceed with the remainder of the Installation guide
as written:

1. Add the Coder Helm repo:

   ```console
   helm repo add coder https://helm.coder.com
   ```

1. Pull the `tar` file, which will be written to `./coder-<version>.tgz`:

   ```console
   helm pull coder/coder
   ```

1. Install Coder from the archive:

   ```console
   helm install coder coder-<version>.tgz \
      --namespace=coder
      --values=<my-values.yaml>
   ```
