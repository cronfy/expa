#!/usr/bin/env bash

currentDir="$PWD"

function logNeedsAction() {
	local gitdir="$1"
	shift

	echo " ** $gitdir"
	echo "   " "$@"
	echo -e "\n"
}

find ./ -name '.git' -type d | grep -v '/deploy/_build/var/' | while read gitdir ; do
	cd "$currentDir"
	cd "$gitdir/.."

	status="$(git status -s)" || {
		logNeedsAction "$gitdir" "Error getting status"  
		continue
	}

	unpushed="$(git cherry -v)" || {
		logNeedsAction "$gitdir" "Error getting unpushed"  
		continue
	}

	[ -z "${status}" ] || {
		logNeedsAction "$gitdir" "Has not commited"  
		continue
	}

	[ -z "${unpushed}" ] || {
		logNeedsAction "$gitdir" "Has not pushed"  
		continue
	}
done

