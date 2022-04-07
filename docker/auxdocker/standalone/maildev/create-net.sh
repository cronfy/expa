#!/usr/bin/env bash

set -eu -o pipefail

interface="$1"
ip="$2"

# tnx https://unix.stackexchange.com/a/152334

if [ "$(whoami)" != "root" ] ; then
	echo "Use sudo." >&2
	exit 1
fi

modprobe dummy

ip link add $interface type dummy

# maildev
ip addr add $ip/24 dev $interface

ip addr show dev $interface | grep $ip

