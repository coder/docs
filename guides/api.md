---
title: "Public API"
description: Learn more about Coder's API.
state: alpha
---

To help you integrate Coder into your automated workflows, we've documented our
API.

## Authentication

Use of the API requires authentication with a session token. You can generate
one using the [Coder CLI](../cli/index.md):

1. If you haven't already, [authenticate](../cli/installation.md#authenticate)
   your CLI with your environment.
1. Run `coder tokens create <TOKEN_NAME>`
1. Save the token that's returned to use in your HTTP headers:

   ```sh
   curl \
   -X GET "https://apidocs.coder.com/api/" \
   -H "accept: application/json" \
   -H "Session-Token: Bk...nt"
   ```

## Documentation

Please note that the API is under active development; expect breaking changes as
we finalize the endpoints. We will place stable API routes under the `/api/v1`
path.

<a href="https://apidocs.coder.com">
    <button> Swagger Docs </button>
</a>
