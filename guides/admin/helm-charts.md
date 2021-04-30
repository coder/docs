---
title: Helm charts
description: Learn how to modify configuration values in Helm charts.
---

This article will show you how to modify the default configuration values in
Coder's Helm chart.

> You can [see the contents of Coder's Helm
> chart](https://github.com/cdr/enterprise-helm/blob/master/values.yaml) on
> GitHub.

1. Get a copy of your existing Helm chart and save it as `current-values.yaml`

   ```console
   helm show values coder/coder > current-values.yaml
   ```

1. Open the `current-values.yaml` file using the text editor of your choice

1. Edit the `current-values.yaml` file as needed. **Be sure to remove the lines
   that you are _not_ modifying. Otherwise, the contents of
   `current-values.yaml` will override those in the default chart**

1. Save the `current-values.yaml` file

1. Update your Coder deployment with your new Helm chart values. Be sure to
   replace the placeholder value in the following command with your Coder
   version):

   ```console
   helm upgrade coder coder/coder -n coder --version=<VERSION> -f current-values.yaml
   ```

   **Note:** You must complete this step every time you update the Helm chart
   values
