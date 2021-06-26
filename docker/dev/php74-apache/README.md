# php74-apache

## Юзер

```
docker-compose exec web /app/docker/php/extras/set-www-data-user-id.sh `id -u`
```

## /app/web - document root

```
docker-compose exec web /app/docker/php/extras/set-document-root.sh /app/web
docker-compose restart
```

## Установка расширения php

```
docker-compose exec web /app/docker/php/extras/install-php-extensions.sh imagick
```

## Включение модуля apache

```
docker-compose exec web /app/docker/php/extras/enable-apache-module.sh expires
docker-compose restart
```

## Директория после входа в www-data

```
docker-compose exec web /app/docker/php/extras/set-directory-after-login.sh /app
```

## Решение проблем с конфигами

Спасибо https://stackoverflow.com/a/50166314/1775065

```
docker cp testdocker_web_1:/etc/apache2/conf-enabled/devdenv.conf .
# ... edit ...
docker cp devdenv.conf testdocker_web_1:/etc/apache2/conf-enabled/devdenv.conf
```
