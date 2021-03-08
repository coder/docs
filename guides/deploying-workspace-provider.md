---
title: Deploying A Workspace Provider
description: Learn how to deploy a remote Workspace Provider with helm and the coder CLI
---

[Workspace Providers](./admin/environment-management/workspace-providers.md) 
are logic groups of resources you can deploy workspaces onto. Like the Coder
deployment, Workspace Providers are deployed via a helm chart into the kubernetes
cluster you'd like to provision new workspaces into. 

First, you must create a new 