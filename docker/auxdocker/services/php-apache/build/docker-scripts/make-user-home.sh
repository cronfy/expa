#!/usr/bin/env bash

# Создаёт пользователя и домашнюю директорию пользователя, чтобы работали утилиты, создающие кеш в домашней директории, 
# например, composer.

set -eu -o pipefail

USER_ID="$1"
HOME_DIR="/home/app"

[ -z "$USER_ID" ] && {
	echo "Failed to detect UID $USER_ID." >&2
	exit 1
}

[ "$USER_ID" = "0" ] && {
	echo "Container is running under root user, this is not expected / supported. Use \`user:\` option in docker-compose.yml" >&2
	exit 1
}

useradd -d "$HOME_DIR" -m -u $USER_ID -s /bin/bash app || {
	echo "Failed to create user with uid $USER_ID." >&2
	exit 1
}

echo "User $USER_ID (home dir $HOME_DIR) has been successfully created."



