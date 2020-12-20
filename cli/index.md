---
title: "Command Line"
icon: "<svg viewBox=\"0 0 512 466\" xmlns=\"http://www.w3.org/2000/svg\">\n<path d=\"M46.5 0.837754C20.5 0.837754 0 22.3052 0 49.5321V122.94V196.348V221.062V245.776V270.489V343.898V417.306C0 444.533 20.5 466 46.5 466H256H465.5C491.5 466 512 444.533 512 417.306V343.898V244.205V195.511V122.102V48.6944C512 21.4674 491.5 0 465.5 0H256H46.5V0.837754Z\" />\n<path d=\"M70.1 73.1V99.1L140.2 140.1L70.1 181.1V207.1L186.7 140.1L70.1 73.1ZM185.9 186.5V210.1H302.5V186.5H185.9Z\" fill=\"white\" />\n</svg>"
---

Coder provides an [open-source CLI](https://github.com/cdr/coder-cli) that
allows you to interact with your environments using your local machine.

## Getting Started

The Coder CLI is automatically injected and authenticated inside of all Coder Environments.

The CLI is also useful for use on your local machine. Before you can use the CLI locally,
you'll need to download, install, and authenticate with Coder.

### Download and Install

You'll find all CLI releases on
[GitHub](https://github.com/cdr/coder-cli/releases). Make sure to download the appropriate
build for your platform.

The version numbering for CLI releases mirrors the version numbering for Coder
releases. Download the CLI release whose version number matches your Coder
version number.

### Authenticate

Once you've installed the CLI, run `coder login [https://coder.domain.com]` to authenticate with your
Coder account.

If you're logged into Coder via your web browser, the process proceeds
automatically; otherwise, you'll be asked to provide your username and password.

#### Static authentication

To support cases where the browser-based authentication flow isn't appropriate, such as in CI/CD pipelines,
the Coder CLI can also be authenticated with the `CODER_TOKEN` and `CODER_URL` environment variables.

Generate a static authentication token with the following command:
```bash
coder tokens create my-token
```

## Reference

For a full list of the Coder CLI commands available, see the [reference
pages](https://github.com/cdr/coder-cli/blob/master/docs/coder.md).
