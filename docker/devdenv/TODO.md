
 * export LC_CTYPE=C.UTF-8
 * ssh-agent: 
   * autostart agent
 * chsh -s /bin/bash www-data
 * mysql
   * `echo '!includedir /etc/my.cnf.d'  >> /etc/my.cnf`


## bootstrap

1. Вынести в любую папку.

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

