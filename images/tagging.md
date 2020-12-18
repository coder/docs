---
title: "Tagging"
description: "Learn how to manage image versions inside Coder."
---

[Image tags](https://docs.docker.com/engine/reference/commandline/tag/) are variants of your base image. Users can publish new image tags containing updated
dependencies and tooling useful for work on the project.

To import a tag, go to "Images" and navigate to your image. Click "Add Tag" and provide the tag name when prompted.

When a new version of a tag is updated, Coder notifies users of that tag to [rebuild](../environments/lifecycle.md#rebuilds).

## Default Tag

Each image has a default tag, which appears at the top of the list and is marked
by an asterisk. Coder automatically selects the default tag when you create an
environment.

![Add tag](../assets/default-tag.png)
