
## bootstrap

1. Сделать раздельные файлы (шаблоны) .env и docker-compose.yml для разных сервисов.

## php-apache 

 1. Запуск не от root
 2. Ответ на портах своего IP.
 3. Установка конфигурации для Битрикса.
 4. ssh-ключ для composer (форвард ssh-agent)
 
## mysql

 1. Запуск не от root.
 2. Хранение БД в volume.
    * тест на down
 3. Настройка под Битрикс.
    * поможет `echo '!includedir /etc/my.cnf.d'  >> /etc/my.cnf`

