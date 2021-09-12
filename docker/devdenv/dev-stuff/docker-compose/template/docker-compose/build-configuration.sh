#!/usr/bin/env bash

set -eu -o pipefail

. .builder.env

PROJECT_PATH="$PWD"
BUILDER_DIR_RELATIVE="$BUILDER_DIR"
cd "$BUILDER_DIR_RELATIVE"
BUILDER_DIR_ABS="$PWD"

#
# build dockerfiles and scripts
#

echo -e "\n#\n# Building services\n#\n"

cd "$BUILDER_DIR_ABS"

buildDirAbs="$BUILDER_DIR_ABS/build"
buildDirRelativeToProject="$BUILDER_DIR_RELATIVE/build"
servicesDirAbs="$BUILDER_DIR_ABS/services"
localDirAbs="$BUILDER_DIR_ABS/local"
buildDirRelativeToLocal="../build"

echo "Preparing empty directory..."
rm -rf "$buildDirAbs"

echo "Copying services..."
cp -a "$servicesDirAbs" "$buildDirAbs"

echo "Copying local overrides..."
cd "$localDirAbs"

find ./ -type f | while read file ; do
	dir="$(dirname "$file")"
	mkdir -p "$dir"
	cat "$file" >> "$buildDirRelativeToLocal/$file"
done

echo "Done building services"

#
# build .env
#

envTemplateFile="$BUILDER_DIR_ABS/.env.template.sh"
envDestFile="$buildDirAbs/.env"
envLocalOverrideFile="$localDirAbs/.env"

echo -e "\n#\n# Building .env\n#\n"

cd "$BUILDER_DIR_ABS"

ENV__COMPOSE_FILE="./docker-compose.yml"
ENV__SERVICES_DIR="$buildDirRelativeToProject"
ENV__USER_UID=`id -u`
ENV__USER_GID=`id -g`

builtServiceDirs="$(find "$buildDirAbs" -maxdepth 1 -mindepth 1 -type d)"

for serviceDir in $builtServiceDirs ; do
	serviceName="$(basename "$serviceDir")"
	serviceEnvTemplateFile="$serviceDir/.env"

	ENV__COMPOSE_FILE="$ENV__COMPOSE_FILE:$buildDirRelativeToProject/docker-compose.$serviceName.yml"
done

. "$envTemplateFile" > "$buildDirAbs/.env"

builtServiceDirs="$(find "$buildDirAbs" -maxdepth 1 -mindepth 1 -type d)"

for serviceDir in $builtServiceDirs ; do
	serviceName="$(basename "$serviceDir")"
	serviceEnvTemplateFile="$serviceDir/.env"

	if [ ! -f "$serviceEnvTemplateFile" ] ; then
		continue
	fi

	{
		echo -e "#\n# SERVICE: $serviceName\n#\n"
		cat "$serviceEnvTemplateFile"
	} >> "$envDestFile"
done

[ -f "$envLocalOverrideFile" ] && {
  echo -e "#\n# LOCAL overrides\n#\n"
  cat "$envLocalOverrideFile"
} >> "$envDestFile"

echo "Done building .env"

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
