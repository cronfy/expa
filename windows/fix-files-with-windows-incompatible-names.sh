#!/usr/bin/env bash

#
# Переименовывает файлы, чьи имена несовместимы с Windows, рекурсивно, начиная с текущей директории.
# В Windows в названиях файлов нельзя использовать символы: \ / : * ? " < > |
# При запуске без аргументов просто показвает, что будет сделано.
# Для реальной замены нужно указать аргумент --real
# Пример:
#   fix-files-with-windows-incompatible-names.sh --real
#

set -eu -o pipefail

function fixName() {
	local dirname="$1" basename="$2" mode="$3" newName
	newName="$(echo "$basename" | sed 's/[\\/:*?"<>|]/_/g')"

	echo "$dirname/$basename -> $newName"

	if [ "$mode" = "real" ] ; then
		mv "$dirname/$basename" "$dirname/$newName"
	elif [ "$mode" = "dry" ] ; then
		:
	else
		echo "Unknown mode: $mode" >&2
		exit 1
	fi
}

function printName() {
	local dirname"$1" basename="$2"

	echo "$dirname/$basename"
}

function getFiles() {
	find ./ -type f ! -regex './.git/?.*' 
}

function getFolders() {
	find ./ -type d ! -regex './.git/?.*' 
}

function processAll() {
	local mode="$1"

	while read name ; do
		basename="$(basename "$name")"
		dirname="$(dirname "$name")"
		# if echo "$basename" | grep 

		if echo "$basename" | grep -q '[\\/:*?"<>|]' ; then
			fixName "$dirname" "$basename" "$mode"
		fi
	done
}

ARG1="${1:---dry}"

case "$ARG1" in
	--dry)
		# не переименовывать файлы, только выводить, что будет сделано
		MODE="dry"
		;;
	--real)
		# переименовывать файлы
		MODE="real"
		;;
	*)
		echo "Unknown arg '$ARG1'" >&2
		exit 1
		;;
esac

getFiles   | processAll "$MODE"
getFolders | processAll "$MODE"


