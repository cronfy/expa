# dev docker-compose templates

## Быстрый старт (разворачивание первого проекта)

1. `dev-stuff/docker-compose/`
1. copy some of `services/`
1. `./dev-stuff/docker-compose/bootstrap.sh .` 
1. В `src/` развернуть код проекта.
1. tune `.env` - network, document root
5. ??? По необходимости в Dockerfile дописать специфичные для проекта команды. TODO include+ https://github.com/edrevo/dockerfile-plus
6. `docker-compose up -d`
7. Поправилил что-то в Dockerfile - `docker-compose up -d --build`

## См. также

 * https://github.com/frontid/dockerizer

