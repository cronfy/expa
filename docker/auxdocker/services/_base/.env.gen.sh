#!/usr/bin/env bash

set -eu -o pipefail

SERVICES_DIR="${1:-.}"
OVERRIDES_FILE_NAME="${2:-}"

. $SERVICES_DIR/_include/build.lib.sh

function getServiceDirs() {
    find "$SERVICES_DIR" -maxdepth 1 -mindepth 1 -type d
}

function echoDotEnvHeader() {
  echo "SERVICES_PATH=\"$SERVICES_PATH\"

RUN_AS_UID=\"$userUid\"
RUN_AS_GID=\"$userGid\"

# первые *три* октета для выделения IP сервисам в проекте
BASE_NET=$BASE_NET
BASE_NET_MASK=$BASE_NET_MASK
"
}

userUid=`id -u` 
userGid=`id -g`

[ -f "$OVERRIDES_FILE_NAME" ] && {
	. "$OVERRIDES_FILE_NAME"
}

ensureVariablesConfigured "$OVERRIDES_FILE_NAME" SERVICES_PATH BASE_NET BASE_NET_MASK

echoDotEnvHeader

