---
title: "Lifecycle"
description: "Learn about the lifecycle of Environments."
---

Environments aren't intended to always stay on.

## Rebuilds

When an [Environment](index.md) is rebuilt, nothing is [persisted](#persistence) outside
of the home directory.

Rebuilds are helpful when you want to update an Image, or start from scratch.

## Auto-Off

Environments automatically shut-off after inactivity.

## Persistence

Home directory. Everything outside is reset.

## Hooks

Learn more about `/coder/configure`.
