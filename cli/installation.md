---
title: Installation and setup
description: Learn how to install and configure the Coder CLI.
---

## Getting started

The Coder CLI is automatically injected and authenticated inside of all Coder
workspaces.

You can also use the CLI on your local machine. To do so, you'll need to
download, install, and authenticate the CLI with Coder.

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

If you're logged into Coder via your web browser, the process will open a new
browser window that displays a session token. Copy the token, and paste it into
the terminal prompt.

### Static authentication

To support cases where the browser-based authentication flow isn't appropriate,
such as in CI/CD pipelines, the Coder CLI can also be authenticated with the
`CODER_TOKEN` and `CODER_URL` environment variables.

Generate a static authentication token with the following command:

```console
coder tokens create my-token
```

## Update

To update the CLI to the version corresponding to your current Coder deployment,
run (you will be asked to confirm all changes before they're performed):

```console
coder update
```

The `coder update` command accepts the following arguments:

- `--coder`: specify the Coder instance the CLI should use to query the version
- `--version`: specify the version that the CLI should download and upgrade to
- `--force`: omit prompts asking for change confirmations

**Note:** Coder CLI will not update if it is under certain paths.
