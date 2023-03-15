# Public API

To help you integrate Coder into your automated workflows, we've documented our
API.

## Documentation

Please note that the API is under active development; expect breaking changes as
we finalize the endpoints.

<a href="https://apidocs.coder.com">
    <button> Swagger Docs </button>
</a>

## Authentication

Use of the API requires authentication with a session token. You can generate
one using the [Coder CLI](../cli/index.md):

1. If you haven't already, [authenticate](../cli/installation.md#authenticate)
   your CLI with your workspace.
1. Run `coder tokens create <TOKEN_NAME>`
1. Save the token that's returned to use in your HTTP headers:

   ```sh
   curl \
   -X GET "https://apidocs.coder.com/api/" \
   -H "accept: application/json" \
   -H "Session-Token: Bk...nt"
   ```

## Examples

These are example Coder API calls for common tasks. Note that the site-manager
role is required to be perform specific actions and without it, API results will
be limited to a user's member role.

> Assign your Access URL, Session-Token and other resources like images and
> workspaces to variables for easier substitution in the curl commands.

```sh
export ACCESS_URL "https://coder.acme.com"
export API_KEY="MUdzI3UMvF-Qlwovt-----0CL0kTbADQl"
export API_ROUTE="api/v0"
export IMAGE_ID="622b3f6e-dd6fd08-----ba38c73c9639"
```

### Example: get active SSH users in 1 week increments in August

> For a full list of categories and filters, see
> [Usage metrics](../admin/metrics.md).

```sh
# Currently in the private API
API_ROUTE=api/private curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/metrics/activity?\
start=2022-08-01T00:00:00.000000Z&end=2022-08-31T00:00:00.000000Z\
&category=tunnel\
&interval=1 week" \
--header "Session-Token: $API_KEY"
```

### Example: get audit logs for a workspace and resource type

```sh
curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/audit?\
limit=10\
&resource_id=$WS_ID_PHP\
&resource_type=environment" \
  --header "Session-Token: $API_KEY"
```

### Example: get audit logs for workspace created in a Unix seconds period

```sh
curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/audit?\
range_start=1646092800\
&range_end=1646697600\
&resource_type=environment\
&action=create" \
--header "Session-Token: $API_KEY"
```

### Example: generate a session token for a user

```sh
curl --request POST \
  --url $ACCESS_URL/$API_ROUTE/api-keys/613e75c4-faef2f87-----376e1f229b6 \
  --header "Content-Type: application/json" \
  --header "Session-Token: $API_KEY" \
  --data '{
    "name": "my-session-token"
  }'
```

### Example: get the workspaces created by a user

```sh
curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/workspaces?users=$USER_ID" \
  --header "Session-Token: $API_KEY"
```

### Example: get the workspaces built with a specific image

```sh
curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/images/$IMAGE_ID" \
  --header "Session-Token: $API_KEY"
```

### Example: get info about an image tag and workspaces built with it

> Change `latest` to your tag name

```sh
curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/images/$IMAGE_ID/tags/latest" \
  --header "Session-Token: $API_KEY"
```

### Example: get the workspaces in a specific organization

```sh
curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/workspaces?orgs=$ORG_ID" \
  --header "Session-Token: $API_KEY"
```

### Example: get the images authorized in a specific organization

```sh
curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/images/?org=$ORG_ID&workspaces=false" \
  --header "Session-Token: $API_KEY"
```

### Example: update image tags from a registry

```sh
curl --request POST \
  --url "$ACCESS_URL/$API_ROUTE/images/$IMAGE_ID" \
  --header "Session-Token: $API_KEY" \
  --data "{}"
```

### Example: update the compute resources baseline for an image

```sh
curl --request PATCH \
  --url "$ACCESS_URL/$API_ROUTE/images/$IMAGE_ID" \
  --header "Session-Token: $API_KEY" \
  --data "{
      \"default_memory_gb\": 8,
      \"description\": \"3/26/22 increased RAM from 4 to 8 GB\"
  }"
```

### Example: import a container image

```sh
curl --request POST \
  --url "$ACCESS_URL/$API_ROUTE/images" \
  --header "Session-Token: $API_KEY" \
  --header "Content-Type: application/json" \
  --data "{
  \"default_cpu_cores\": 4,
  \"default_disk_gb\": 4,
  \"default_memory_gb\": 10,
  \"description\": \"IntelliJ 2020.3.4\",
  \"org_id\": \"$ORG_ID\",
  \"registry_id\": \"$REG_ID\",
  \"repository\": \"marktmilligan/intellij-ultimate\",
  \"tag\": \"2020.3.4\"
}"
```

### Example: deprecate an image (and its tags)

```sh
curl --request PATCH \
  --url "$ACCESS_URL/$API_ROUTE/images/$IMAGE_ID" \
  --header "Session-Token: $API_KEY" \
  --data "{
      \"deprecated\": true
  }"
```

### Example: Restart/rebuild a workspace

```sh
curl --request PATCH \
  --url $ACCESS_URL/$API_ROUTE/workspaces/$WS_ID \
  --header "Content-Type: application/json" \
  --header "Session-Token: $API_KEY" \
  --data "{}"
```

### Example: How to create a user

```sh
curl --request POST \
  --url "$ACCESS_URL/$API_ROUTE/users" \
  --header "Session-Token: $API_KEY" \
  --header "Content-Type: application/json" \
  --data "{
  \"email\": \"bob@acme.com\",
  \"login_type\": \"built-in\",
  \"name\": \"Bob Barker\",
  \"password\": \"password\",
  \"temporary_password\": true,
  \"username\": \"bbarker\",
  \"organizations\": [\"default\",\"$ORG_ID\"]
}"
```

### Example: Get a user's public SSH key

```sh
curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/users/$USER_ID/sshkey" \
  --header "Session-Token: $API_KEY"
```

### Example: Create a dev URL

```sh
curl --request POST \
  --url "$ACCESS_URL/$API_ROUTE/workspaces/$WS_ID_PHP/devurls" \
  --header "Session-Token: $API_KEY" \
  --header "Content-Type: application/json" \
  --data "{
  \"access\": \"PRIVATE\",
  \"name\": \"phpapp4\",
  \"port\": 1029,
  \"scheme\": \"http\"
}"
```

### Example: Update a dev URL including access control level

```sh
curl --request PUT \
  --url "$ACCESS_URL/$API_ROUTE/workspaces/$WS_ID_PHP/devurls/$DU_ID_PHP" \
  --header "Session-Token: $API_KEY" \
  --header "Content-Type: application/json" \
  --data "{
  \"access\": \"AUTHED\",
  \"name\": \"phpapp4\",
  \"port\": 1029,
  \"scheme\": \"http\"
}"
```

### Example: List dev URLs

```sh
curl --request GET \
  --url "$ACCESS_URL/$API_ROUTE/workspaces/$WS_ID_PHP/devurls" \
  --header "Session-Token: $API_KEY"
```

### Example: Delete a dev URL

```sh
curl --request DELETE \
  --url "$ACCESS_URL/$API_ROUTE/workspaces/$WS_ID_PHP/devurls/$DU_ID_PHP \
  --header "Session-Token: $API_KEY" \
  --header "Content-Type: application/json" \
  --data "{
}"
```
