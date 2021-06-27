#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-indocker.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }


DOCUMENT_ROOT=$1

echo "Setting document root as $DOCUMENT_ROOT"

sed -i "s=DocumentRoot .*=DocumentRoot $DOCUMENT_ROOT=" /etc/apache2/sites-enabled/000-default.conf
sed "s={{DOCUMENT_ROOT}}=$DOCUMENT_ROOT=" < "`dirname $0`/set-document-root-apache-conf.conf" > /etc/apache2/conf-enabled/set-document-root-apache-conf.conf

setSuccess

requireContainerRestart

