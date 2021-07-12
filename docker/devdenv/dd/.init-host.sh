
PROJECT_DIRECTORY_RELATIVE_TO_US=..
ROOT_DIRECTORY=""
SERVICE_PATH=""

set -eu -o pipefail

if [ "${1-}" = "-vvv" ] ; then
  shift
  set -x
fi

success=no

processAutoErrorMessage() {
  [ "yes" != "$success" ] && echo "Error occured" >&2 || true
}

throwException() {
	local msg="${1:-unspecified error}"

	echo "$msg" >&2

	exit 1
}

setSuccess() {
	success=yes
	echo "OK"
}

requireExplicitSuccess() {
	local value="${1:-true}"

	if [ "$value" = "false" ] ; then
		trap - EXIT
		return
	fi

	if [ "$value" = "true" ] ; then
		trap "processAutoErrorMessage" EXIT
		return
	fi

	throwException "requireExplicitSuccess: Invalid argument: $value"
}

getRootDirectory() {
  if [ -z "$ROOT_DIRECTORY" ] ; then
    local currentDirectory="$PWD"
    local rootPathRelativeToScript="${ROOT_PATH_RELATIVE_TO_SCRIPT-}"

    [ -z "$rootPathRelativeToScript" ] && throwException "ROOT_PATH_RELATIVE_TO_SCRIPT env variable must be set"
    [ -z "$PROJECT_DIRECTORY_RELATIVE_TO_US" ] && throwException "PROJECT_DIRECTORY_RELATIVE_TO_US env variable must be set"

    cd "$(dirname $0)/$rootPathRelativeToScript"
    cd "$PROJECT_DIRECTORY_RELATIVE_TO_US"

    ROOT_DIRECTORY="$PWD"

    cd "$currentDirectory"
  fi

  echo "$ROOT_DIRECTORY"
}

getServicePath() {
    if [ -z "$SERVICE_PATH" ] ; then
    local currentDirectory="$PWD"
    local servicePathRelativeToScript="${SERVICE_PATH_RELATIVE_TO_SCRIPT-}"

    [ -z "$servicePathRelativeToScript" ] && throwException "SERVICE_PATH_RELATIVE_TO_SCRIPT env variable must be set"

    cd "$(dirname $0)/$servicePathRelativeToScript"

    SERVICE_PATH="$PWD"

    cd "$currentDirectory"
  fi

  echo "$SERVICE_PATH"
}

cdToProjectDirectory() {
  cd "$(getRootDirectory)"
}

loadEnv() {
  . "$(getRootDirectory)"/.env
}

getAutoServiceName() {
  basename "$(getServicePath)"
}

getServiceBuildDir() {
  local service="$1"

  echo "$(getRootDirectory)/$BUILD_SCRIPTS_LOCAL_PATH/$service"
}

runServiceBuildScript() {
  if [ "${1-}" = "--service" ] ; then
	  serviceName="$2"
	  shift 2
  else
	  serviceName="$(getAutoServiceName)"
  fi

  local script="$1" currentDirectory="$PWD"
  shift

  cdToProjectDirectory

  docker-compose exec "$serviceName" "$BUILD_SCRIPTS_MOUNT_POINT/$serviceName/build/indocker/$script" "$@"

  cd "$currentDirectory"
}

restartService() {
    local serviceName="$(getAutoServiceName)" currentDirectory="$PWD"

    cdToProjectDirectory

    docker-compose restart "$serviceName"

    cd "$currentDirectory"
}


loadEnv

requireExplicitSuccess true

