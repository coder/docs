---
title: "Dev URLs"
description: "Learn about accessing and sharing web servers running in your environment."
---

Dev URLs allow you to access web servers running in your environment.

> You must have [Dev URLs enabled](../admin/devurls.md).

## Creating a Dev URL

You can create a Dev URL from the Environments page.

1. In the "Dev URLs" section, click "Add URL".
   
   ![Create a Dev URL](../assets/create-devurl.png)

2. Specify a friendly name to use as the prefix for the generated URL (defaults to the provided port).

3. Indicate who can [access](#access-control) the URL and click "Save" to create.

## Using Dev URLs

To access a Dev URL, start a web service on the specified port.

You can directly access web services in your environment by visiting:

```text
<port>-<environment_name>-<username>.domain
```

## Access Control

You can set the access level for each Dev URL:

- **Private** - Only the owner of the environment can access the URL
- **Organization** - Anyone in the same organization as the environment can
  access the URL
- **Authorized Users** - Anyone logged in to your Coder instance can access the
  URL
- **Public** - Anyone on the internet can access the URL
