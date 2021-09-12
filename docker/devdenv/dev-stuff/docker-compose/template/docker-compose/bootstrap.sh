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

SERVICE_DIRS="$(find "$DOCKER_COMPOSE_CONF_DIR/build" -maxdepth 1 -mindepth 1 -type d )"

echo "Creating conf symlinks..."

ln -nfs "$DOCKER_COMPOSE_CONF_DIR/build/.env" .env
ln -nfs "$DOCKER_COMPOSE_CONF_DIR/build/docker-compose.yml" docker-compose.yml

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
