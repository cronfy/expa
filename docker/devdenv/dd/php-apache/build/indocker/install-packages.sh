#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-indocker.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }

SKIP_APT_UPDATE=false

if [ "$1" = "--skip-apt-update" ] ; then
  SKIP_APT_UPDATE=true
  shift
fi

echo "Installing packages:" "$@"

if [ "$SKIP_APT_UPDATE" != "true" ] ; then
  apt update
fi

apt install -y "$@"

setSuccess

requireContainerRestart

