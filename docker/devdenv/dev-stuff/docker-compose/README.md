# dev docker-compose templates

## Быстрый старт (разворачивание первого проекта)

1. В папке проекта создать `dev-stuff/docker-compose/`
1. Скопировать туда содержимое template/docker-compose/
1. Скопировать в корень проекта `.builder.env` из `.builder.env.template` и прописать там относительный путь до билдера - `dev-stuff/docker-compose/`
1. Скопировать нужные сервисы из `services/` в `dev-stuff/docker-compose/services/`
1. В папке проекта запустить `./dev-stuff/docker-compose/build-configuration.sh` 
1. Появится docler-compose/build/.env.
1. Взять этот .env за основу и Создать `dev-stuff/docker-compose/local/.env` и прописать там локальные настройки сервисов (network, document root...).
1. Опять в папке проекта запустить `./dev-stuff/docker-compose/build-configuration.sh` 
1. В папке проекта запустить `./dev-stuff/docker-compose/bootstrap.sh` 
1. В `src/` развернуть код проекта.
1. `docker-compose up -d`

Если требуется доработать Dockerfile сервисов:

1. В local/ содздать файлы с тем же путем и названием, что и оригинальный сервис (напирмер, Dockerfile).
1. Дописать туда то, что дополнится в конец файла.
1. Можно также добавлять несуществующие файлы.
1. Запустить build-configuration.sh из папки проекта.
1. `docker-compose up -d --build`

## См. также

 * https://github.com/frontid/dockerizer
 * include+ https://github.com/edrevo/dockerfile-plus

