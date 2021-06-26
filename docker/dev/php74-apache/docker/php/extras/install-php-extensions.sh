#!/usr/bin/env bash

success=no ; onExit() { [ "yes" != "$success" ] && echo "Error occured" >&2; } ; trap "onExit" EXIT ; set -eu -o pipefail


EXTENSIONS="$@"

echo "Installing php extensions: $EXTENSIONS"

install-php-extensions $EXTENSIONS

success=yes

echo OK

