# Разворачивание

1. Создать папку проекта. Создать в нем src/ и dev-stuff/.
2. В src/ положить проект. В dev-stuff/ - содержимое отсюда.
3. В .env указать свой UID и GID пользователя.
4. В docker-compose.yml 
    * указать IP сервисов, TODO -> .env
5. В php-apache/Dockerfile
    * указать путь к document root, если это не /app/web (/app/www или просто /app, по ситуации) TODO -> .env / ARG
5. Создать симлинки из корня проекта на файлы .env и скрипты сервисов в этой папке. TODO bootstrap.sh
6. По необходимости в Dockerfile дописать специфичные для проекта команды. TODO include+ https://github.com/edrevo/dockerfile-plus
7. docker-compose up -d

