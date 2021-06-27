#!/usr/bin/env bash

. "$(dirname "$0")/.init.sh" || { echo "FAILED TO INIT" >&2 ; exit 1; }

serviceName="$(getAutoServiceName)"

runServiceBuildScript configure-bitrix-settings-w-mbstring.sh

docker-compose restart "$serviceName"

setSuccess
