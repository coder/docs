# Workspace limits

You can set the maximum number of workspaces that each user can create. To do
so, [update your Helm chart](../../guides/admin/helm-charts.md) and set the
`CODER_MAX_WORKSPACES_PER_USER` parameter to the maximum allowable number:

```yaml
# Allow each user to create no more than 100 workspaces
coderd:
  extraEnvs:
    - name: CODER_MAX_WORKSPACES_PER_USER
      value: "100"
```
