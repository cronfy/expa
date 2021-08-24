#!/usr/bin/env bash

set -eu -o pipefail

PROJECT_PATH="${1:-}"

if [ -z "$PROJECT_PATH" ] ; then
	echo "Syntax:  $(basename "$0") <project_directory>" >&2
	exit 1
fi

if [ "$(realpath ".")" = "$(realpath "$PROJECT_PATH")" ] ; then
	DOCKER_COMPOSE_CONF_PATH="$(dirname "$0")"
else
	DOCKER_COMPOSE_CONF_PATH="$(dirname "$0")"
	DOCKER_COMPOSE_CONF_PATH="$(realpath "$DOCKER_COMPOSE_CONF_PATH")"
fi

cd "$PROJECT_PATH"

echo "Creating symlinks"

ln -nfs "$DOCKER_COMPOSE_CONF_PATH/.env" .env
ln -nfs "$DOCKER_COMPOSE_CONF_PATH/docker-compose.yml" docker-compose.yml
ln -nfs "$DOCKER_COMPOSE_CONF_PATH/php-apache.sh" php-apache

echo "Creating project source directory src/"

mkdir -p src

echo "Done."
