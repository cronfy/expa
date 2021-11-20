#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-indocker.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }


if [ "$#" != 1 ] ; then
  {
    echo "Syntax: `basename $0` <sql_mode>"
    echo "(sql mode may be empty string, but must be set explicitly)"
  } >&2
  
  exit 1
fi

SQL_MODE="$1"

echo "Setting sql mode"

echo -e "[mysqld]\nsql_mode=\"$SQL_MODE\"" > /etc/my.cnf.d/sql-mode.cnf

setSuccess

requireContainerRestart

