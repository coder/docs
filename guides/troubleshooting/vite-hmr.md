---
title: Vite & HMR
description: Learn how to resolve issues Vite and hot-module-reloading (HMR).
---

When using Vite and accessing your app via Dev URLs, you may encounter issues
with hot-module-reloading (HMR) not working.

## Why this happens

Vite runs a WebSocket for HMR and assumes the client will listen on a specific
port. This leads and Vite HMR and the client never connecting.

## How to fix

Edit your `vite.config.js` file and add the following:

```js
 server: {
    hmr: {
      clientPort: 443
    },
  },
```

If this doesn't resolve the issue, please
[contact us](https://coder.com/contact) for further support.
