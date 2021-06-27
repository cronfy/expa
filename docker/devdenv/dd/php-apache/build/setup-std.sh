#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-host.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }

serviceName="$(getAutoServiceName)"

# composer requirements
runServiceBuildScript install-packages.sh git unzip
# dev env
runServiceBuildScript install-packages.sh --skip-apt-update less openssh-client wget mc vim telnet
# other
runServiceBuildScript set-www-data-user-id.sh "$(id -u)"
runServiceBuildScript set-directory-after-login.sh /app
runServiceBuildScript set-document-root.sh /app/web
runServiceBuildScript install-php-extensions.sh mbstring json iconv imagick mysqli zip mysqli gd
runServiceBuildScript enable-apache-modules.sh rewrite expires headers

docker-compose restart "$serviceName"

setSuccess
