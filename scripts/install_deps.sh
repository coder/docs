#!/usr/bin/env bash
#
# This script installs dependencies to /usr/local/bin.

set -euo pipefail
PROJECT_ROOT=$(git rev-parse --show-toplevel)
cd "$PROJECT_ROOT"
source "./scripts/lib.sh"

TMPDIR=$(mktemp -d)
BINDIR="/usr/local/bin"

curl_flags=(
  --silent
  --show-error
  --location
)

# Install packages via apt where available
apt_packages=(
  # ShellCheck to perform static code analysis of shell scripts
  shellcheck
  # xmlstarlet to process sitemap.xml file
  xmlstarlet
)
run_trace false sudo DEBIAN_FRONTEND="noninteractive" \
  apt-get install --no-install-recommends --yes "${apt_packages[@]}"

# lychee to check links
LYCHEE_VERSION="0.7.1"
run_trace false curl "${curl_flags[@]}" "https://github.com/lycheeverse/lychee/releases/download/v${LYCHEE_VERSION}/lychee-v${LYCHEE_VERSION}-x86_64-unknown-linux-gnu.tar.gz" \| \
  tar --extract --gzip --directory="$TMPDIR" --file=- "lychee"

run_trace false sudo install --mode=0755 --target-directory="$BINDIR" "$TMPDIR/*"

run_trace false command -v \
  lychee \
  shellcheck \
  xmlstarlet

run_trace false sudo rm --verbose --recursive --force "$TMPDIR"
