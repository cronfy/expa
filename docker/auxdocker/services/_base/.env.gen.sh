#!/usr/bin/env bash

set -eu -o pipefail

SERVICES_DIR="${1:-.}"
OVERRIDES_FILE="${2:-}"

function getServiceDirs() {
    find "$SERVICES_DIR" -maxdepth 1 -mindepth 1 -type d
}

function echoDotEnvHeader() {
  echo "SERVICES_PATH=\"$SERVICES_DIR\"

RUN_AS_UID=\"$userUid\"
RUN_AS_GID=\"$userGid\"

# первые *три* октета для выделения IP сервисам в проекте
BASE_NET=$BASE_NET
BASE_NET_MASK=$BASE_NET_MASK
"
}

userUid=`id -u` 
userGid=`id -g`

BASE_NET=172.10.1
BASE_NET_MASK=24

[ -n "$OVERRIDES_FILE" ] && {
	. "$OVERRIDES_FILE"
}

echoDotEnvHeader

