---
description: "Learn how to create an environment and start developing with Coder."
next: "../editor/index.md"
---

An Environment is your personal computer on {{@product_name}}.

Environments are created from common images that are shared among your team.
By using the same images, you no longer have the "it works on my machine" problem.

When an update is pushed to the Image your Environment uses, you'll be able to rebuild!
Your home directory persists after rebuilds, so feel free to configure to your liking.

{{#> example}}
{{#> dashboard}}

1. Navigate to the Environments page.

   ![Environments](./assets/environments-nav.png)

2. Click "New Environment".

   ![New Environment](./assets/environments-new.png)

3. Name your environment, select an image, and click "Create Environment".

   ![Create Environment](./assets/environments-create.png)

4. Your environment will start creating... you'll be notified once it finishes!

{{/dashboard}}
{{#> cli}}

```bash
coder envs create dev --image
```

Optionally, append `--follow` to watch your Environment build.

{{/cli}}
{{/example}}
