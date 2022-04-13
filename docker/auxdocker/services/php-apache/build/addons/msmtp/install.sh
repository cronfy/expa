#!/usr/bin/env bash

set -eu -o pipefail

apt-get update && apt install msmtp -y

echo "
account default
from php-apache@container
host maildev
port 1025
logfile /var/log/msmtp.log
" > /etc/msmtprc

touch /var/log/msmtp.log
chmod 777 /var/log/msmtp.log

echo "
sendmail_path = /usr/bin/msmtp -t
" > /usr/local/etc/php/conf.d/99-msmtp.ini


