---
title: Installation and Setup
description: Learn how to install and configure the Coder CLI.
---

## Getting Started

The Coder CLI is automatically injected and authenticated inside of all Coder
Environments.

The CLI is also useful for use on your local machine. Before you can use the CLI
locally, you'll need to download, install, and authenticate with Coder.

## Installation

### Homebrew (Mac, Linux)

The version numbering for CLI releases mirrors the version numbering for Coder
releases. Download the CLI release whose version number matches your Coder
version number.

```sh
brew install cdr/coder/coder-cli
```

### Download (Windows, Linux, Mac)

Download the latest [release](https://github.com/cdr/coder-cli/releases):

1. Click a release and download the tar file for your operating system (ex: coder-cli-linux-amd64.tar.gz)
2. Extract the `coder` binary.

### Authenticate

Once you've installed the CLI, authenticate the client with your Coder account.

```bash
coder login [https://coder.domain.com]
```

If you're logged into Coder via your web browser, the process proceeds
automatically; otherwise, you'll be asked to provide your username and password.

#### Static authentication

To support cases where the browser-based authentication flow isn't appropriate,
such as in CI/CD pipelines, the Coder CLI can also be authenticated with the
`CODER_TOKEN` and `CODER_URL` environment variables.

Generate a static authentication token with the following command:

```bash
coder tokens create my-token
```

## Full Reference

For a full list of the Coder CLI commands available, see the [reference
pages](https://github.com/cdr/coder-cli/blob/master/docs/coder.md).
