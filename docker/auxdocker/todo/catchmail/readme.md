
apt update
apt install gnupg2 # для apt-key add

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-update # еще раз, чтобы поставился нужный yarn
RUN /root/apt-wget.sh nodejs yarn


# mail
RUN yarn global add catchmail
RUN yarn global add maildev
COPY data/catchmail-wrapper /usr/local/bin/
RUN mkdir -p /var/www/log
RUN chown www-data:staff /var/www/log
COPY sendmail-catchmail.ini /usr/local/etc/php/conf.d/

# use

```
maildev &
php testmail.php
/var/www/log/catchmail.log
```

http://php-apache-IP:1080/


