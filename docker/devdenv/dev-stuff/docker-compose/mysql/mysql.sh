#!/usr/bin/env bash

cd "$(dirname "$0")"

SERVICE_NAME=mysql

case "$1" in
	build|rebuild)
		docker-compose up -d --build "$SERVICE_NAME"
		;;
	restart)
		docker-compose restart "$SERVICE_NAME"
		;;
	root)
		docker-compose exec -u root "$SERVICE_NAME" bash
		;;
	*)
		if test -t 0 ; then
			# shell
			docker-compose exec "$SERVICE_NAME" mysql --default-character-set=utf8 "$@"
		else
			# pipe
			docker-compose exec -T "$SERVICE_NAME" mysql --default-character-set=utf8 "$@"
		fi
		;;
esac



