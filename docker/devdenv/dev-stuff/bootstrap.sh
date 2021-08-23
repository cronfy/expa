#!/usr/bin/env bash

if [ "$(dirname "$0")" = "." ] ; then
	echo "Script was not meant to be run in it's directory. Run it in project's directory." >&2
	exit 1
fi

DOCKER_COMPOSE_PATH="$(dirname "$0")/docker-compose"

ln -nfs "$DOCKER_COMPOSE_PATH/.env"
ln -nfs "$DOCKER_COMPOSE_PATH/docker-compose.yml"
ln -nfs "$DOCKER_COMPOSE_PATH/php-apache.sh" php-apache

mkdir -p src

