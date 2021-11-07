#!/usr/bin/env bash

set -eu -o pipefail

SERVICES_DIR="${1:-.}"
CONF_DEST_DIR="${2:-.}"

function getServiceDirs() {
    find "$SERVICES_DIR" -maxdepth 1 -mindepth 1 -type d
}

function echoDotEnvHeader() {
  local userUid=`id -u` userGid=`id -g`

  echo "
SERVICES_PATH=\"$SERVICES_DIR\"

RUN_AS_UID=\"$userUid\"
RUN_AS_GID=\"$userGid\"

# первые *три* октета для выделения IP сервисам в проекте
BASE_NET=172.10.1
BASE_NET_MASK=24
"
}

function echoComposeHeader() {
  echo "
version: '2.0'

networks:
  app_net:
    driver: bridge
    ipam:
      driver: default
      config:
      - subnet: \${BASE_NET}.0/\${BASE_NET_MASK}
        gateway: \${BASE_NET}.1
"
}

function buildDotEnvFileTemplate() {
  echoDotEnvHeader
  echoServicesDotenvBlocks
}

function buildComposeFileTemplate() {
  echoComposeHeader
  echo "services:"
  echoServicesComposeBlocks
}

function echoServicesDotenvBlocks() {
  local serviceNumber=0

  for serviceDir in $(getServiceDirs) ; do
    serviceNumber=$(($serviceNumber + 1))
    serviceIp=$(($serviceNumber + 1)) # ip gateway = 1, поэтому ip первого сервиса = 2
    serviceName="$(basename "$serviceDir")"
    serviceEnvTemplateFile="$serviceDir/.env"

    if [ ! -f "$serviceEnvTemplateFile" ] ; then
      continue
    fi

    echo -e "#\n# SERVICE: $serviceName\n#\n"
    cat "$serviceEnvTemplateFile" | sed "s/{{service_ip}}/$serviceIp/"
  done
}

function echoServicesComposeBlocks() {
  for serviceDir in $(getServiceDirs) ; do
    serviceName="$(basename "$serviceDir")"
    serviceTemplateFile="$serviceDir/docker-compose.yml"

    if [ ! -f "$serviceTemplateFile" ] ; then
      continue
    fi

    cat "$serviceTemplateFile" | grep -Ev '^(services|version):'
  done
}

buildDotEnvFileTemplate > "$CONF_DEST_DIR/.env.template"
buildComposeFileTemplate > "$CONF_DEST_DIR/docker-compose.yml.template"

exit

#
# build docker-compose.yml
#

composeMainFile="$BUILDER_DIR_ABS/docker-compose.yml"
composeDestDir="$buildDirAbs"

echo -e "\n#\n# Building docker-compose.yml\n#\n"

cd "$BUILDER_DIR_ABS"

cp "$composeMainFile" "$composeDestDir/docker-compose.yml"

builtServiceDirs="$(find "$buildDirAbs" -maxdepth 1 -mindepth 1 -type d)"

for serviceDir in $builtServiceDirs ; do
	serviceName="$(basename "$serviceDir")"
	serviceComposeFile="$serviceDir/docker-compose.yml"

  cp "$serviceComposeFile" "$composeDestDir/docker-compose.$serviceName.yml"
done

echo "Done building docker-compose.yml"

#
# End
#

echo -e "\nDone."

