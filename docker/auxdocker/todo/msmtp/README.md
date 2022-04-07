https://www.codeproject.com/Articles/5258262/Replacing-SSMTP-with-MSMTP-in-Docker


apt install ssmtp




vim /etc/msmtprc

account default
from php-apache@container
host maildev.dev.doc
port 25
logfile /var/log/msmtp.log



chmod 777 /var/log/msmtp.log




vim /usr/local/etc/php/conf.d/99-msmtp.ini

sendmail_path = /usr/bin/msmtp -t
