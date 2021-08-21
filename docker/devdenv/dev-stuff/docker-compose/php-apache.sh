#!/usr/bin/env bash

cd "$(dirname "$0")"

case "$1" in
	build|rebuild)
		docker-compose up -d --build php-apache
		;;
	restart)
		docker-compose restart php-apache
		;;
	root)
		docker-compose exec -u root php-apache bash
		;;
	*)
		if [ $# = "0" ] ; then
			docker-compose exec php-apache bash
		else
			docker-compose exec php-apache "$@"
		fi
		;;
esac



