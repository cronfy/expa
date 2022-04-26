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

	local overrideFileName="$SERVICES_DIR/.env.$serviceName.override"

	"$serviceDir/.env.gen.sh" "$SERVICES_DIR" "$overrideFileName" | sed "s/{{service_ip}}/$serviceIp/"
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

    if [ -f "$serviceTemplateFile" ] ; then
        pasteServiceYml "$serviceDir" "$serviceName"
    fi

    local serviceGeneratorFile

    serviceGeneratorFile="$serviceDir/docker-compose.generate.sh"

    if [ -f "$serviceGeneratorFile" ] ; then
        generateServiceYml "$serviceDir" "$serviceName"
    fi

    if [ -f "$serviceDir/docker-compose.yml.volumes" ] ; then
       HAVE_VOLUMES=yes
    fi
  done
}

function pasteServiceYml()
{
  local serviceDir="$1" serviceName="$2"

  serviceTemplateFile="$serviceDir/docker-compose.yml"

  cat "$serviceTemplateFile" | grep -Ev '^(services|version):'
}

function generateServiceYml()
{
  local serviceDir="$1" serviceName="$2"

  serviceGeneratorFile="$serviceDir/docker-compose.generate.sh"

  $serviceGeneratorFile
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

buildDotEnvFileTemplate > "$CONF_DEST_DIR/.env"
echo "Created: .env"

buildComposeFileTemplate > "$CONF_DEST_DIR/docker-compose.yml"
echoComposeVolumesBlock >> "$CONF_DEST_DIR/docker-compose.yml"
echo "Created: docker-compose.yml"

