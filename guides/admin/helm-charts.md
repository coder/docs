---
title: Helm charts
description: Learn how to modify configuration values in Helm charts.
---

This article will show you how to modify the default configuration values in
Coder's helm chart.

> You can
> [see the contents of Coder's helm chart](https://github.com/cdr/enterprise-helm/blob/master/values.yaml)
> on GitHub.

1. Get a copy of your existing helm chart and save it as `values.yaml`

   ```console
   helm show values coder/coder > values.yaml
   ```

1. Open the `values.yaml` file using the text editor of your choice

1. Edit the `values.yaml` file as needed. **Be sure to remove the lines that you
   are _not_ modifying, otherwise the contents of `values.yaml` will override
   those in the default chart**

1. Save the `values.yaml` file

1. Update your Coder deployment with your new helm chart values. Be sure to
   replace the placeholder value in the following command with your Coder
   version):

   ```console
   helm upgrade coder coder/coder -n coder --version=<VERSION> -f values.yaml
   ```

   **Note:** You must complete this step every time you update the helm chart
   values
