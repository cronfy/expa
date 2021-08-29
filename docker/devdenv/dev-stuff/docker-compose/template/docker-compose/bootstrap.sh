#!/usr/bin/env bash

set -eu -o pipefail

PROJECT_PATH="${1:-}"
DOCKER_COMPOSE_CONF_DIR="${2:-}"

if [ -z "$DOCKER_COMPOSE_CONF_DIR" ] && [ "$PROJECT_PATH" = "." ] ; then
	DOCKER_COMPOSE_CONF_DIR="$(dirname "$0")"
fi

if [ -z "$PROJECT_PATH" ] || [ -z "$DOCKER_COMPOSE_CONF_DIR" ]  ; then
	echo "Syntax:  $(basename "$0") <project_directory> [docker_compose_conf_directory]" >&2
	exit 1
fi

cd "$PROJECT_PATH"
PROJECT_PATH="$PWD"

#
# .env
#

ENVTEMPLATE_FILE="$DOCKER_COMPOSE_CONF_DIR/.env.template.sh"
ENVTEMPLATE_TMP="$(mktemp envtemplate.XXXXXX)"
trap "rm -f $ENVTEMPLATE_TMP" EXIT

ENV_SERVICES_DIR="$DOCKER_COMPOSE_CONF_DIR/services"
ENV_COMPOSE_FILE="./docker-compose.yml"
ENV_USER_UID=`id -u`
ENV_USER_GID=`id -g`

SERVICE_DIRS="$(find "$DOCKER_COMPOSE_CONF_DIR/services" -maxdepth 1 -mindepth 1 -type d )"

for serviceDir in $SERVICE_DIRS ; do
	serviceName="$(basename "$serviceDir")"
	ENV_COMPOSE_FILE="$ENV_COMPOSE_FILE:$DOCKER_COMPOSE_CONF_DIR/services/$serviceName/docker-compose.yml"
done

. "$ENVTEMPLATE_FILE" > "$ENVTEMPLATE_TMP"

for serviceDir in $SERVICE_DIRS ; do
	serviceName="$(basename "$serviceDir")"
	serviceEnvTemplateFile="$serviceDir/.env"

	if [ ! -f "$serviceEnvTemplateFile" ] ; then
		continue
	fi

	{
		echo -e "#\n# SERVICE: $serviceName\n#\n"
		cat "$serviceEnvTemplateFile"
	} >> "$ENVTEMPLATE_TMP"
done

if [ -e "$DOCKER_COMPOSE_CONF_DIR/.env" ] ; then
	echo -e "*\n* Suggested .env:\n*\n"
	cat "$ENVTEMPLATE_TMP"
	echo -e "\n*\n* (.env already exists, not overwriting)\n*\n"
	rm "$ENVTEMPLATE_TMP"
else
	mv "$ENVTEMPLATE_TMP" "$DOCKER_COMPOSE_CONF_DIR/.env"
fi

echo "Creating conf symlinks..."

ln -nfs "$DOCKER_COMPOSE_CONF_DIR/.env" .env
ln -nfs "$DOCKER_COMPOSE_CONF_DIR/docker-compose.yml" docker-compose.yml

echo "Creating service control symlinks..."

for serviceDir in $SERVICE_DIRS ; do
	serviceName="$(basename "$serviceDir")"
	controlScript="$serviceDir/$serviceName.sh"

	if [ ! -f "$controlScript" ] ; then
		continue
	fi

	ln -nfs "$controlScript" "$(basename "$controlScript" .sh)"
done

echo "Creating project source directory src/..."

mkdir -p src

echo "Done."
