---
title: Installation and setup
description: Learn how to install and configure the Coder CLI.
---

## Getting started

The Coder CLI is automatically injected and authenticated inside of all Coder
Environments.

The CLI is also useful for use on your local machine. Before you can use the CLI
locally, you'll need to download, install, and authenticate with Coder.

## Installation

The version numbering for CLI releases mirrors the version numbering for Coder
releases. Download the CLI release whose version number matches your Coder
version number.

### Homebrew (Mac, Linux)

```sh
brew install cdr/coder/coder-cli
```

### Download (Windows, Linux, Mac)

Download releases [from GitHub](https://github.com/cdr/coder-cli/releases):

1. Click a release and download the tar file for your operating system (ex:
   coder-cli-linux-amd64.tar.gz)
1. Extract the `coder` binary and copy it to a location you've added to your
   `PATH` environment variable

## Authenticate

Once you've installed the CLI, authenticate the client with your Coder account.

```console
coder login [https://coder.domain.com]
```

If you're logged into Coder via your web browser, the process proceeds
automatically; otherwise, you'll be asked to provide your username and password.

### Static authentication

To support cases where the browser-based authentication flow isn't appropriate,
such as in CI/CD pipelines, the Coder CLI can also be authenticated with the
`CODER_TOKEN` and `CODER_URL` environment variables.

Generate a static authentication token with the following command:

```console
coder tokens create my-token
```
