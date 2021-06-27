#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-host.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }

requireExplicitSuccess false

serviceName="$(getAutoServiceName)"

docker-compose exec -u www-data "$serviceName" bash -l
