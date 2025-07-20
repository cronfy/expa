#!/usr/bin/env bash

set -eu -o pipefail

TOOLS_DIR="`dirname $0`"

SCRIPT_SELF="`basename $0`" "$TOOLS_DIR"/dump-db-from-host.sh \
	--host stage.project.dev \
	--database stage_db \
	--mysql-command "sudo /optstage/run-mysql" \
	--mysqldump-command "sudo /opt/stage/run-mysql mysqldump" 

