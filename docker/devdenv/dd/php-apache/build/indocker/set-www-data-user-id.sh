#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-indocker.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }


DOCKER_USER_ID="$1"

echo "Setting UID $DOCKER_USER_ID for user www-data"

usermod -u "$DOCKER_USER_ID" www-data
usermod -d /var/www www-data
chown -R www-data:www-data /var/www

setSuccess

requireContainerRestart

