#!/usr/bin/env bash

set -eu -o pipefail

cd "$(dirname $0)"

echo "Configuring for bitrix (w/mbstring)"

cp php.conf.d/*  /usr/local/etc/php/conf.d/

echo "Done."
