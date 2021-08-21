FROM php:7.4-apache as base

#
# BASE: Базовая сборка типового php-apache для разработки
#

# install-php-extensions: Установить установщик расширений php 
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync

# composer: Установить composer
RUN install-php-extensions @composer

# composer runtime dependencies: Установить пакеты, которые требуются composer для работы
RUN apt update && apt install -y \
	git \
	unzip 

# common php extensions: Установить часто требуемые расширения php
RUN install-php-extensions mbstring json iconv imagick mysqli zip mysqli gd

# common apache modules: Установить часто требуемые модули apache
RUN a2enmod rewrite expires headers

#
# GENERIC DEV SETTINGS: Общие настройки dev-окружения
#

WORKDIR /root/docker-scripts
COPY docker-scripts .
# docroot: Установить /app/web в качестве document root
RUN ./set-document-root.sh /app/web
# workdir: Установить /app в качестве папки, в которой будут выпоняться команды по умолчанию
WORKDIR /app

#
# PROJECT: Команды, специфичные для проекта
#

FROM base as php-74-myproject

# RUN install-php-extensions bcmath
# ...
