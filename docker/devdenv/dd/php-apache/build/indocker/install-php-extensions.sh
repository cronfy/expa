#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-indocker.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }


echo "Installing php extensions:" "$@"

install-php-extensions "$@"

setSuccess

requireContainerRestart

