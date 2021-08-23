# Разворачивание

1. Создать папку проекта. Положить туда dev-stuff/.
2. Запустить в папке проекта ./dev-stuff/bootstrap.sh . Он создаст src/ и симлинки.
3. В .env указать свой UID и GID пользователя.
5. В php-apache/Dockerfile
    * указать путь к document root, если это не /app/web (/app/www или просто /app, по ситуации) TODO -> .env / ARG
6. По необходимости в Dockerfile дописать специфичные для проекта команды. TODO include+ https://github.com/edrevo/dockerfile-plus
7. docker-compose up -d

