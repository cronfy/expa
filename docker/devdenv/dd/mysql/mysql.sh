#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-host.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }

requireExplicitSuccess false

serviceName="$(getAutoServiceName)"

cdToProjectDirectory "$ROOT_PATH_RELATIVE_TO_SCRIPT"

if test -t 0 ; then
	docker-compose exec "$serviceName" mysql -u root project
else
	docker-compose exec -T "$serviceName" mysql -u root project
fi

