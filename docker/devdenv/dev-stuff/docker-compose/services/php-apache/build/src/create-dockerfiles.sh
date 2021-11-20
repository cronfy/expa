#!/usr/bin/env bash

set -eu -o pipefail

cd `dirname $0`

for phpVer in 7.3 7.4 8.0 ; do
	dockerfileName=Dockerfile-$phpVer

	echo "Creating $dockerfileName..."

	cat "Dockerfile.base.src" "Dockerfile.project.src" | sed "s/{{phpVer}}/$phpVer/" > ../$dockerfileName

	[ -e Dockerfile.local ] && {
		echo -e "\t * with the local supplement."
		cat Dockerfile.local >> ../$dockerfileName
	}

  cat Dockerfile.footer.src >> ../$dockerfileName
done

echo "Done."
