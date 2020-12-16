#!/usr/bin/env bash

set -euxo pipefail

# Creates the GitHub deployment.
DEPLOYMENT_ID=$(curl \
    -X POST \
    -H "Accept: application/vnd.github.ant-man-preview+json" \
    -H "Content-Type: application/json" \
    --user "x-access-token:$GITHUB_TOKEN" \
    --data '{
              "ref": "'$GITHUB_REF'",
              "description": "coder.com",
              "environment": "preview",
              "transient_environment": true,
              "required_contexts": []
            }' \
    https://api.github.com/repos/$GITHUB_REPOSITORY/deployments | jq '.id')

# Remove just in case...
rm -f url.txt

# Starts the vercel deployment.
./ci/steps/vercel_deploy.sh 1> url.txt &

while ! [ -s url.txt ]; do
    # Until the URL is in the file we don't want to create the deployment.
    sleep 1
done

ENVIRONMENT_URL=$(cat url.txt)

# Updates the deployment status to be pending with the build URL above.
curl \
    -X POST \
    -H "Accept: application/vnd.github.flash-preview+json" \
    -H "Content-Type: application/json" \
    --user "x-access-token:$GITHUB_TOKEN" \
    --data '{
              "state": "in_progress",
              "environment_url": "'$ENVIRONMENT_URL'"
            }' \
    https://api.github.com/repos/$GITHUB_REPOSITORY/deployments/$DEPLOYMENT_ID/statuses

# Waiting for the vercel deploy to finish...
wait

curl \
    -X POST \
    -H "Accept: application/vnd.github.ant-man-preview+json" \
    -H "Content-Type: application/json" \
    --user "x-access-token:$GITHUB_TOKEN" \
    --data '{
              "state": "success",
              "environment_url": "'$ENVIRONMENT_URL'"
            }' \
    https://api.github.com/repos/$GITHUB_REPOSITORY/deployments/$DEPLOYMENT_ID/statuses
