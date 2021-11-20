#!/usr/bin/env bash

. "$(dirname "$0")/.init-dir.sh" || { echo " ** FAILED TO INIT BY DIR CONFIG" >&2 ; exit 1; }
. "$(dirname "$0")/$ROOT_PATH_RELATIVE_TO_SCRIPT/.init-indocker.sh" || { echo " ** FAILED TO INIT BY HOST CONFIG" >&2 ; exit 1; }


from="${1-}"

[ -z "$from" ] && {
	echo "Syntax: `basename $0` <from>"
	echo "Example: `basename $0` 172.22.%"
	exit 1
}

echo "Allowing root access from 172.22.*"

mysql -u root -e "$(cat <<EOF
    grant all privileges on *.* to root@"172.22.%" identified by "temp-password";
    set @pwd = (select authentication_string from mysql.user where user = "root" and host = "localhost");
    update mysql.user set authentication_string = @pwd where user = 'root' and host = "$from";
    flush privileges;
EOF
)"

setSuccess

