---
title: "Install a JetBrains IDEs"
description: Learn how to install JetBrains IDEs onto Images.
---

The process of installing an IDE onto your [image](./images) is similar to
installing the IDE onto a local machine.

To see examples demonstrating how to install the various IDEs and configure your
image to work with Coder's multi editor feature, refer to the [sample
images](https://github.com/cdr/enterprise-images) available on GitHub.

## Supported IDEs

Coder can find and start the following IDEs if their binaries exist in your
PATH:

- CLion
- DataGrip
- GoLand
- IntelliJ IDEA Community Edition
- IntelliJ IDEA Ultimate
- Jupyter
- PhpStorm
- PyCharm
- Rider
- RubyMine
- Code OSS (VS Code, installed by default)
- WebStorm

## Required Packages

The following packages are required in your image if you're using an IDE other
than VS Code. They ensure that the IDE can communicate with Coder:

<table>
    <thead>
        <tr>
            <th>Debian Package</th>
            <th>RPM Package</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>openssl</td>
            <td>openssl</td>
            <td>Secure Sockets Layer Toolkit</td>
        </tr>
        <tr>
            <td>libxtst6</td>
            <td>libXtst</td>
            <td>X11 Testing Library</td>
        </tr>
        <tr>
            <td>libxrender1</td>
            <td>libXrender</td>
            <td>X Rendering Extension Client Library</td>
        </tr>
        <tr>
            <td>libfontconfig1</td>
            <td>fontconfig</td>
            <td>Generic Font Configuration Library</td>
        </tr>
        <tr>
            <td>libxi6</td>
            <td>libXi</td>
            <td>X11 Input Extension Library</td>
        </tr>
        <tr>
            <td>libgtk-3-0</td>
            <td>gtk3</td>
            <td>GTK+ Graphical User Interface Library</td>
        </tr>
    </tbody>
</table>
