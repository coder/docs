---
title: Nightly releases
description: Learn how to obtain and use Coder's nightly releases.
---

Coder offers a public nightly release Helm repository that's updated most
weeknights at 12:00 AM Central. Nightly releases may contain unreleased hotfixes
and new features that haven't been documented.

All customers are free to use the nightly release for their deployments.
However, be aware that breaking bugs will sometimes get shipped via our nightly
release pipeline despite both our manual and automated testing processes.
Furthermore, new features that we make available via nightly releases may not be
up to the standard of the mature features we've fully released. These features
may also have inconsistent UI or unimplemented controls.

Occasionally, we will retract a nightly release from the repository if we find
that it causes data loss or includes major bugs/instability issues. This
retraction will not fix your deployment automatically; you must revert to a
backup manually.

> We recommend you backup your database before proceeding with any of the steps
> on this page.

## Obtaining the Nightly Releases

We store nightly releases in
[this Helm repository](https://helm-nightly.coder.com/index.yaml). We store
images in a publicly accessible gcr.io repository.

## Nightly Release Listing

The list of nightly releases is maintained in the Helm repository's index. We
automatically prune old nightly releases, so you'll see a maximum of 100
entries. The easiest way to view the
[index](https://helm-nightly.coder.com/index.yaml) is to obtain it using curl:

```console
$ curl https://helm-nightly.coder.com/index.yaml

apiVersion: v1
entries:
  coder:
  - apiVersion: v2
    created: "2020-09-25T00:02:52.661335099-05:00"
    description: Run Coder in Kubernetes
    digest: 2dd7081a0d4a5106ac458ba1203ca067be19f20d010528cd802e03ea681e8223
    name: coder
    type: application
    urls:
    - https://helm-nightly.coder.com/coder-1.11.0-90-gb0e792c7e-20200924.tgz
        version: 1.11.0-90-gb0e792c7e-20200924
  - ...
generated: "2020-09-28T00:02:05.129533118-05:00"
```

The topmost version under entries.coder is the most recent version. In most
cases, this is the version you'll want to use.

Each nightly version contains a date at the end in `YYYYMMDD` format. This
version will also be displayed in the Coder UI; when contacting support, it's
crucial that you provide the entire version string to us.

For automation purposes, you can use the following one-liner to get the current
nightly version:

```console
# Requires curl, yq, jq
$ curl -sS https://helm-nightly.coder.com/index.yaml \
| yq r --tojson - \
| jq -r "[.entries.coder | sort_by(.created) | reverse][0][0].version"

1.11.0-108-g01693c0e2-20200926
```

## Installing a Nightly Release via Helm

1. Add the Helm repo (if you haven't already):

   ```console
   $ helm repo add coder-nightly https://helm-nightly.coder.com
   "coder-nightly" has been added to your repositories
   ```

1. Install a specific version to the coder namespace (be sure to backup your
   database before running the following command):

   ```console
     $ helm upgrade --namespace coder coder coder-nightly/coder \
     --version <VERSION> --atomic --install

     Release "coder" has been upgraded. Happy Helming!
     NAME: coder
     LAST DEPLOYED: Mon Sep 28 16:38:36 2020
     NAMESPACE: coder
     STATUS: deployed
     REVISION: 2
     TEST SUITE: None
   ```

   The `--atomic` flag instructs Helm to automatically downgrade if the nightly
   release isn't ready within the default timeout of 5 minutes. This automatic
   downgrade on failure is safe and shouldn't require you to manually downgrade
   to your database backup if it occurs.

## Downgrading to a Standard Release

Downgrading is not something we support at this time. If you need to downgrade,
you must revert to the database backup you made before installing the nightly
release.

If your currently installed nightly version is sufficiently older than a
standard release (i.e., more than a week older), consider
[upgrading](../../setup/updating.md) from the nightly release to the standard
release.
