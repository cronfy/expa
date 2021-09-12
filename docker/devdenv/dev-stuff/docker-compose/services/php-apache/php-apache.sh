#!/usr/bin/env bash

cd "$(dirname "$0")"

SERVICE_NAME=php-apache

case "$1" in
	build|rebuild)
		docker-compose up -d --build $SERVICE_NAME
		;;
	restart)
		docker-compose restart $SERVICE_NAME
		;;
	root)
		docker-compose exec -u root $SERVICE_NAME bash
		;;
	ext)
		shift
		docker-compose exec -u root $SERVICE_NAME install-php-extensions "$@"
		;;
	*)
		if [ $# = "0" ] ; then
			docker-compose exec $SERVICE_NAME bash
		else
			docker-compose exec $SERVICE_NAME "$@"
		fi
		;;
esac



