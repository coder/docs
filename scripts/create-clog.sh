#!/usr/bin/env bash
#
# create-clog.sh <version> <release-date>
#
# Dependencies: sed
# 
# Description: Uses template_changelog.md to create a new changelog.
#
# Examples:
#  ./scripts/create-clog.sh "1.18.0" "05/18/2021"


set -eou pipefail

VERSION_DELIM="<% X.Y.Z %>"
RELEASE_DATE_DELIM="<% MM/DD/YYYY %>"
VERSION=""
RELEASE_DATE=""

# usage prints information for how to use this program
function usage () {
  echo "Usage: create-clog <version> <release-date>"
  echo "Create a changelog from a template"
  echo "Arguments:"
  echo "    <version>: A version string 'x.y.z'"
  echo "    <release-date>: A date string 'mm/dd/yyyy'"
}

# init parses arguments and initializes all variables.
function init () {
  lenArgs=2
  if [ "$#" -ne $lenArgs ]; then
    echo "illegal number of arguments."
    echo "Expected: $lenArgs  Received: $#"
    usage
    exit 1
  fi

  if [ -z "${1-}" ]; then
    echo "version argument is empty."
    echo "Expected a version string like 'x.y.z'"
    usage
    exit 1
  fi
  
  if [ -z "${2-}" ]; then
    echo "release-date argument is empty."
    echo "Expected a date string like 'mm/dd/yyyy'"
    usage
    exit 1
  fi
  
  VERSION="$1"
  RELEASE_DATE="$2"
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

# main program
init "$@"
create_from_template
echo "Done"
