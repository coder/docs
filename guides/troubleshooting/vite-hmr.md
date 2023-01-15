# Vite and HMR

When using Vite and accessing your app via
[dev URLs](../../workspaces/devurls.md), you may encounter issues with hot
module reloading (HMR) not working.

## Why this happens

Vite runs a WebSocket for hot module reloading (HMR) and assumes the client will
listen on a specific port. If this isn't the case, Vite HMR and the client never
connect.

## How to fix

Edit your `vite.config.js` file and add the following information to provide the
appropriate port number:

```js
 server: {
    hmr: {
      clientPort: 443
    },
  },
```

If this doesn't resolve the issue, please
[contact us](https://coder.com/contact) for further support.
