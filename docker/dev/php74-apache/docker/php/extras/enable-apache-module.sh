#!/usr/bin/env bash

success=no ; onExit() { [ "yes" != "$success" ] && echo "Error occured" >&2; } ; trap "onExit" EXIT ; set -eu -o pipefail


MODULE="$@"

echo "Enabling apache module: $MODULE"

a2enmod $MODULE

success=yes

echo OK

