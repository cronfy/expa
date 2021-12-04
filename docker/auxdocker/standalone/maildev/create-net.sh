#!/usr/bin/env bash

# tnx https://unix.stackexchange.com/a/152334

if [ "$(whoami)" != "root" ] ; then
	echo "Use sudo." >&2
	exit 1
fi

modprobe dummy

ip link add eth10 type dummy

# maildev
ip addr add 172.10.5.0/24 dev eth10

ip addr show dev eth10 | grep 172.10.5

