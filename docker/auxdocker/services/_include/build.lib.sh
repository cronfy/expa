#!/usr/bin/env bash

function ensureVariablesConfigured() {
  local overrideFileName="$1" anyNotSet=false
  shift

  for var in "$@" ; do
    local value="${!var:-}"

    if [ -z "$value" ]; then
      echo "Необходимо определить переменную $var в файле $overrideFileName" >&2
      anyNotSet=true
    fi
  done

  if [ "$anyNotSet" = "true" ] ; then
    exit 1
  fi
}
