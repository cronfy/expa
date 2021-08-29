#!/usr/bin/env bash

set -eu -o pipefail

DOCUMENT_ROOT=$1

echo "Setting document root as $DOCUMENT_ROOT"

sed -i "s=DocumentRoot .*=DocumentRoot $DOCUMENT_ROOT=" /etc/apache2/sites-enabled/000-default.conf
sed "s={{DOCUMENT_ROOT}}=$DOCUMENT_ROOT=" < "$(dirname "$0")/set-document-root-apache-conf.conf" > /etc/apache2/conf-enabled/set-document-root-apache-conf.conf

