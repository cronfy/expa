#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-host.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }

requireExplicitSuccess false

SERVICE="${1-}"

[ -z "$SERVICE" ] && {
	echo "Syntax: `basename $0` <service_name>"
	exit 1
}

docker-compose up --build -d "$1" 

