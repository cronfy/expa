## СРОЧНО

1. Когда разворачиваешь сервисы, ВООБЩЕ непонятно, откуда брать IP.
2. Можно догадаться, но сложно понять, что брать для создания .env, наверное пусть лучше билдер соберет.
3. IP неудобно, что задаются последним октетом, непонятно.
4. В идеале сделать, чтобы не нужно было пересобирать сборку после изменения своего .env
5. ОЧЕНЬ неудобно, что нельзя править локальный .env

## bootstrap

1. Сделать раздельные файлы (шаблоны) .env и docker-compose.yml для разных сервисов.

## php-apache 

 1. Все-таки надо `useradd -d /home/app -m -u 1000 -s /bin/bash app`, а то composer не может создать себе кеш, т.к. нет пользовательской директории.

 3. Установка конфигурации для Битрикса.
 4. ssh-ключ для composer (форвард ssh-agent)
 
## mysql

 1. Запуск не от root.
 3. Настройка под Битрикс.
    * поможет `echo '!includedir /etc/my.cnf.d'  >> /etc/my.cnf`

## ssh-agent

```bash
cat /home/app/bin/start-agent 

#!/usr/bin/env bash

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
```

```
./php-apache bash -c '. /home/app/bin/start-agent ; composer update yiisoft/yii2-composer'
```


