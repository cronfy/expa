#!/usr/bin/env bash

success=no ; onExit() { [ "yes" != "$success" ] && echo "Error occured" >&2; } ; trap "onExit" EXIT ; set -eu -o pipefail


DIRECTORY_AFTER_LOGIN="${1:-/app}"

echo "Setting directory after login as $DIRECTORY_AFTER_LOGIN"

touch /var/www/.bash_profile

token="# devdend: dir after login"
payload="cd $DIRECTORY_AFTER_LOGIN"

sed -i " /$token/ d" /var/www/.bash_profile
echo "$payload $token" >> /var/www/.bash_profile

success=yes

echo OK

