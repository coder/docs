#!/usr/bin/env bash
#
# validate-manifest.sh [path/to/manifest.json]
#
# Dependencies: bash>=4.x jq tr sort uniq
#
# Description: Ensures consistency of versions specified in manifest.json.

set -euo pipefail

if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
    echo "This script requires at least bash version 4."
    exit 1
fi

if ! command -v jq > /dev/null; then
    echo "This script requires jq to be available."
    exit 1
fi

GIT_ROOT=$(cd "$(dirname "$0")" && git rev-parse --show-toplevel)
MANIFEST_JSON_PATH=${1:-"${GIT_ROOT}/manifest.json"}

declare -a MANIFEST_VERSIONS
declare -a ROUTE_VERSIONS

# Read the versions array in manifest.json
readarray -t MANIFEST_VERSIONS < <(jq -r '
    .versions[]
    | capture("(?<v>[0-9]+\\.[0-9]+)")
    | .v' < "${MANIFEST_JSON_PATH}")

# Read all the child paths of changelog/index.md and extract major.minor version
readarray -t ROUTE_VERSIONS < <(jq -r '
    .routes[]
    | select(.path == "./changelog/index.md")
    | .children[]
    | .path |
    capture("(?<v>[0-9]+\\.[0-9]+)")
    | .v' < "${MANIFEST_JSON_PATH}")

# Compare the two
DIFF=$(echo "${MANIFEST_VERSIONS[@]}" "${ROUTE_VERSIONS[@]}" | tr ' ' '\n' | sort | uniq -u)
if [[ -n $DIFF ]]; then
    echo "manifest.json: missing version for changelog(s): ${DIFF}"
    exit 1
fi

exit 0