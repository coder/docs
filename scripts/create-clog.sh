#!/usr/bin/env bash
#
# create-clog.sh [--version=<version>] [--release-date=<release-date>]
#
# Dependencies: getopt sed
# 
# Description: Uses template_changelog.md to create a new changelog.
#
# Examples:
#  ./scripts/create-clog.sh --version="1.18.0" --release-date="05/18/2021"
#  ./scripts/create-clog.sh --version="1.18.0" --release-date=$(date +%D)


set -eou pipefail

VERSION_DELIM="<% X.Y.Z %>"
RELEASE_DATE_DELIM="<% MM/DD/YYYY %>"
VERSION=""
RELEASE_DATE=""

# usage prints information for how to use this program. Exits with status code
# 1.
function usage () {
  echo "Usage: create-clog [--version=<version>] [--release-date=<release-date>]"
  echo "Create a changelog from a template"
  echo "Arguments:"
  echo "    <version>: A version string 'x.y.z'"
  echo "    <release-date>: A date string 'mm/dd/yyyy'"
  exit 1
}

# init parses arguments and initializes all variables.
function init () {
  options=$(getopt \
            --name="$(basename "$0")" \
            --longoptions=" \
                help, \
                release-date:, \
                version:" \
            --options="h" \
            -- "$@")
  [ $? -eq 0 ] || { 
    usage
  }

  eval set -- "$options"
  
  while true; do
    case "${1:-}" in
      -h|--help)
        usage
        ;;
      --version)
        shift;
        VERSION="$1"
        ;;
      --release-date)
        shift;
        RELEASE_DATE="$1"
        ;;
      --)
        shift
        break
        ;;
    esac
    shift
  done

  if [ -z "$VERSION" ]; then
    echo "version argument is empty."
    echo "Expected a version string like 'x.y.z'"
    usage
  fi

  if [ -z "$RELEASE_DATE" ]; then
    echo "release-date argument is empty."
    echo "Expected a date string like 'mm/dd/yyyy'"
    usage
  fi
}

# create_from_template creates a new changelog file from template_changelog.md
# using VERSION and RELEASE_DATE.
function create_from_template () {
  echo "Creating template using version: $VERSION and release date: $RELEASE_DATE"
  pushd "$(git rev-parse --show-toplevel)" > /dev/null
    clogPath="./changelog/$VERSION.md"
    cp ./scripts/template_changelog.md "$clogPath"
    sed -i "s|$VERSION_DELIM|$VERSION|g" "$clogPath"
    sed -i "s|$RELEASE_DATE_DELIM|$RELEASE_DATE|g" "$clogPath"
  popd > /dev/null
}

# update_manifest calls a NodeJS script to update manifest.JSON using VERSION
function update_manifest () {
  echo "Calling add_clog_to_manifest.ts to update manifest.json"
  pushd "$(git rev-parse --show-toplevel)" > /dev/null
    ./node_modules/.bin/ts-node ./scripts/add_clog_to_manifest.ts --version="$VERSION"
  popd > /dev/null
}

# main program
init "$@"
create_from_template
update_manifest
echo "Done"
