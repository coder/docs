---
title: Installation and Setup
description: Learn how to install and configure the Coder CLI.
---

## Getting Started

The Coder CLI is automatically injected and authenticated inside of all Coder
Environments.

The CLI is also useful for use on your local machine. Before you can use the CLI
locally, you'll need to download, install, and authenticate with Coder.

### Download and Install

You'll find all CLI releases on
[GitHub](https://github.com/cdr/coder-cli/releases). Make sure to download the
appropriate build for your platform.

The version numbering for CLI releases mirrors the version numbering for Coder
releases. Download the CLI release whose version number matches your Coder
version number.

### Authenticate

Once you've installed the CLI, run `coder login [https://coder.domain.com]` to
authenticate with your Coder account.

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

## Reference

For a full list of the Coder CLI commands available, see the [reference
pages](https://github.com/cdr/coder-cli/blob/master/docs/coder.md).
