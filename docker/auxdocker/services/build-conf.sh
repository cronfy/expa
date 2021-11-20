#!/usr/bin/env bash

set -eu -o pipefail

SERVICES_DIR="${1:-.}"
CONF_DEST_DIR="${2:-.}"

HAVE_VOLUMES=no

function getServiceDirs() {
    find "$SERVICES_DIR" -maxdepth 1 -mindepth 1 -type d | sort
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
  echoServicesDotenvBlocks
}

function buildComposeFileTemplate() {
  echoComposeHeader
  echo "services:"
  echoServicesComposeBlocks
}

function echoDotEnvServiceHeader() {
  local serviceName="$1"

  echo -e "#\n# SERVICE: $serviceName\n#\n"
}

function echoServicesDotenvBlocks() {
  local serviceNumber=0

  for serviceDir in $(getServiceDirs) ; do
    serviceNumber=$(($serviceNumber + 1))
    serviceIp=$(($serviceNumber + 1)) # ip gateway = 1, поэтому ip первого сервиса = 2
    serviceName="$(basename "$serviceDir")"
    serviceEnvTemplateFile="$serviceDir/.env"

   if [ -x "$serviceDir/.env.gen.sh" ] ; then
	echoDotEnvServiceHeader "$serviceName"

	local overrideFile="$SERVICES_DIR/.env.$serviceName.override"
	[ ! -f "$overrideFile" ] && overrideFile=""

	"$serviceDir/.env.gen.sh" "$SERVICES_DIR" "$overrideFile"
   elif [ -f "$serviceEnvTemplateFile" ] ; then
	echoDotEnvServiceHeader "$serviceName"
        cat "$serviceEnvTemplateFile" | sed "s/{{service_ip}}/$serviceIp/"
   fi
  done
}

function echoServicesComposeBlocks() {
  local serviceTemplateFile serviceName serviceDir

  for serviceDir in $(getServiceDirs) ; do
    serviceName="$(basename "$serviceDir")"
    serviceTemplateFile="$serviceDir/docker-compose.yml"

    [ -f "$serviceDir/docker-compose.yml.volumes" ] && HAVE_VOLUMES=yes

    if [ ! -f "$serviceTemplateFile" ] ; then
      continue
    fi

    cat "$serviceTemplateFile" | grep -Ev '^(services|version):'
  done
}

function echoComposeVolumesBlock() {
  [ "$HAVE_VOLUMES" != "yes" ] && return

  local serviceVolumesFile serviceName serviceDir

  echo -e "\nvolumes:"

  for serviceDir in $(getServiceDirs) ; do
    serviceName="$(basename "$serviceDir")"
    serviceVolumesFile="$serviceDir/docker-compose.yml.volumes"

    if [ ! -f "$serviceVolumesFile" ] ; then
      continue
    fi

    cat "$serviceVolumesFile" | grep -Ev '^\s*(volumes:\s*)?$'
  done
}


buildDotEnvFileTemplate > "$CONF_DEST_DIR/.env.template"
buildComposeFileTemplate > "$CONF_DEST_DIR/docker-compose.yml.template"
echoComposeVolumesBlock >> "$CONF_DEST_DIR/docker-compose.yml.template"
