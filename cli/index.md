---
title: "Command Line"
icon: "<svg viewBox=\"0 0 512 466\" xmlns=\"http://www.w3.org/2000/svg\">\n<path d=\"M46.5 0.837754C20.5 0.837754 0 22.3052 0 49.5321V122.94V196.348V221.062V245.776V270.489V343.898V417.306C0 444.533 20.5 466 46.5 466H256H465.5C491.5 466 512 444.533 512 417.306V343.898V244.205V195.511V122.102V48.6944C512 21.4674 491.5 0 465.5 0H256H46.5V0.837754Z\" />\n<path d=\"M70.1 73.1V99.1L140.2 140.1L70.1 181.1V207.1L186.7 140.1L70.1 73.1ZM185.9 186.5V210.1H302.5V186.5H185.9Z\" fill=\"white\" />\n</svg>"
---

Coder provides an [open-source CLI](https://github.com/cdr/coder-cli) that
allows you to interact with your environments using your local machine.

## Getting Started

Before you can use the CLI, you'll need to download, install, and authenticate
with Coder.

### Step 1: Download and Install

You'll find all CLI releases on
[GitHub](https://github.com/cdr/coder-cli/releases).

The version numbering for CLI releases mirrors the version numbering for Coder
releases. Download the CLI release whose version number matches your Coder
version number.

#### Linux Installation

1. Download the **coder-cli-linux-amd64.tar.gz** file that corresponds with the
   Coder version you're using
2. Extract the **coder** binary from the .tar file. For example:

```bash
cd ~/go/bin
tar -xvf ~/Downloads/coder-cli-linux-amd64.tar.gz
```

#### macOS Installation

1. Download the **coder-cli-darwin-amd64.tar.gz** file that corresponds with the
   Coder version you're using
2. macOS should automatically extract the CLI for you. Move the **coder** binary
   to the location of your choice (e.g., Applications)
3. To open the CLI for the first time, hold the **control** key while clicking
   on the executable and following the prompts presented. This allows you to
   override the OS security features

### Step 2: Authenticate

Once you've installed the CLI, launch the CLI and authenticate it with your
Coder deployment by running `coder login`.

If you're logged into Coder via your web browser, the process proceeds
automatically; otherwise, you'll be asked to provide your username and password.

## Reference

For a full list of the Coder CLI commands available, see the [reference
pages](https://github.com/cdr/coder-cli/blob/master/docs/coder.md).
