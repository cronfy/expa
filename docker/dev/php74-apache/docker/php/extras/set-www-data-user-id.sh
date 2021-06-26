#!/usr/bin/env bash

success=no ; onExit() { [ "yes" != "$success" ] && echo "Error occured" >&2; } ; trap "onExit" EXIT ; set -eu -o pipefail


DOCKER_USER_ID=$1

echo "Setting UID $DOCKER_USER_ID for user www-data"

usermod -u $DOCKER_USER_ID www-data
usermod -d /var/www www-data
chown -R www-data:www-data /var/www

success=yes

echo "OK"

