
CONFIG_TOKEN=devdenv

success=no

onExit() {
  [ "yes" != "$success" ] && echo "Error occured" >&2 || true
}

trap "onExit" EXIT

set -eu -o pipefail

setSuccess() {
	success=yes
	echo "OK"
}

requireContainerRestart() {
	echo " ** Container restart required."
}

