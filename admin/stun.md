---
title: "Direct workspace connections"
description: Learn how to enable P2P connections to workspaces.
---

Coder supports the use of [WebRTC STUN](https://en.wikipedia.org/wiki/STUN),
enabling point-to-point, direct connections to workspaces. Direct connections to
workspaces help avoid the need to proxy traffic, reducing latency.

To connect to workspaces using WebRTC STUN:

1. In the Coder UI, go to **Manage** > **Admin** > **Infrastructure**.
1. Scroll down to **P2P workspace connections**, and provide the **STUN URI**.

> If you don't have a STUN server, you can use Google's publicly accessible
> option. The URL for Google's STUN server is `stun:stun.l.google.com:19302`.
