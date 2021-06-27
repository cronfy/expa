#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-indocker.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }


DIRECTORY_AFTER_LOGIN="${1:-/app}"

echo "Setting directory after login as $DIRECTORY_AFTER_LOGIN"

touch /var/www/.bash_profile

token="# $CONFIG_TOKEN: dir after login"
payload="cd $DIRECTORY_AFTER_LOGIN"

sed -i " /$token/ d" /var/www/.bash_profile
echo "$payload $token" >> /var/www/.bash_profile

setSuccess


