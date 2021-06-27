#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-host.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }

requireExplicitSuccess false

serviceName="${1-}"

[ -z "$serviceName" ] && {
	echo "Syntax: $(basename "$0") <service_name>"
	exit 1
}

serviceBuildDirectory="$(getServiceBuildDir "$serviceName")"
shellRootEntryScript="$serviceBuildDirectory/root.sh"

if [ -e "$shellRootEntryScript" ] ; then
  $shellRootEntryScript
else
  docker-compose exec "$serviceName" bash
fi
