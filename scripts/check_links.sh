#!/usr/bin/env bash
#
# This script installs dependencies to /usr/local/bin.

set -euo pipefail
PROJECT_ROOT=$(git rev-parse --show-toplevel)
cd "$PROJECT_ROOT"
source "./scripts/lib.sh"

DRY_RUN=false
BASE_URL="https://coder.com/docs"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"

function usage() {
  echo "Usage: $(basename "$0") [options]"
  echo
  echo "This checks the links relative to a given Base URL."
  echo
  echo "Options:"
  echo " -h, --help                  Show this help text and exit"
  echo " --dry-run=false             Show commands that would run, but do not"
  echo "                             run them (optional, default false)"
  echo " --base-url=<url>            Base URL to scan, which must contain a"
  echo "                             sitemap.xml file (optional, default"
  echo "                             '$BASE_URL')"
  echo " --github-token=<token>      GitHub access token to avoid rate limiting"
  echo "                             for GitHub URLs (optional, default"
  echo "                             '$GITHUB_TOKEN')"
  exit 1
}

# Allow a failing exit status, as user input can cause this
set +o errexit
options=$(getopt \
            --name="$(basename "$0")" \
            --longoptions=" \
                help, \
                dry-run::, \
                base-url:, \
                github-token:" \
            --options="h" \
            -- "$@")
# allow checking the exit code separately here, because we need both
# the response data and the exit code
# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
  usage
fi
set -o errexit

eval set -- "$options"
while true; do
  case "${1:-}" in
  --dry-run)
    shift
    if [ -z "$1" ] || [ "$1" = true ]; then
      DRY_RUN=true
    else
      DRY_RUN=false
    fi
    ;;
  --base-url)
    shift
    BASE_URL="$1"
    ;;
  --github-token)
    shift
    GITHUB_TOKEN="$1"
    ;;
  -h|--help)
    usage
    ;;
  --)
    shift
    break
    ;;
  *)
    # Default case, print an error and quit. This code shouldn't be
    # reachable, because getopt should return an error exit code.
    echo "Unknown option: $1"
    usage
    ;;
  esac
  shift
done

if [ -z "$BASE_URL" ]; then
  echo "A base URL is required, pass --base-url."
  exit 1
fi

curl_flags=(
  --silent
)

xmlstarlet_flags=(
  -N 'sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"'
  --template
  --value-of '"/sitemap:urlset/sitemap:url/sitemap:loc"'
  --nl
)

lychee_flags=(
  --base-url "'"$BASE_URL"'"
  --exclude-all-private
  --exclude-link-local
  --exclude-loopback
  --exclude-mail
  --exclude-private
  --no-progress
  --scheme http
  --scheme https
)

if [ -n "$GITHUB_TOKEN" ]; then
  lychee_flags+=(--github-token "'"$GITHUB_TOKEN"'")
fi

SITES=$(run_trace false curl "${curl_flags[@]}" "$BASE_URL/sitemap.xml" \| xmlstarlet select "${xmlstarlet_flags[@]}" -)

mapfile -t sites <<< "$SITES"

run_trace $DRY_RUN lychee "${lychee_flags[@]}" -- "${sites[@]}"
