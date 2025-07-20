#!/usr/bin/env bash

set -eu -o pipefail
SCRIPT_SELF=${SCRIPT_SELF:-`basename $0`}

function assertOutputRedirected() {
    if [ -t 1 ] ; then
      {
            echo "Скрипт выводит дамп БД. Вывод скрипта необходимо перенаправить в файл."
            echo "Например:"
            echo ""
            echo "    $SCRIPT_SELF ... аргументы ... > db.sql.gz"
            exit 1
      } >&2
    fi
}

function syntax() {
    echo "Использование: $SCRIPT_SELF --host host --database database [ --mysql-command mysql-command ] [ --mysqldump-command mysqldump-command ]"
    echo "Где:"
    echo "        host              - хост БД для подключения по ssh"
    echo "        database          - название БД"
    echo "        mysql-command     - команда для вызова mysql на host"
    echo "        mysqldump-command - команда для вызова mysqldump на host"
}

function syntaxErrorFailExit() {
  local message="$1"

  syntax >&2
  echo >&2
  echo "$message" >&2
  exit 1
}

function errorFailExit() {
  local message="$1"

  echo >&2
  echo "$message" >&2
  exit 1
}

function msg() {
    local message="$1"

    # в stderr, т. к. скрипт всегда работает с перенаправлением вывода stdout
    echo "$message" >&2
}

function errorMsg() {
    local message="$1"

    echo "$message" >&2
}

DB_HOST=""
DB_NAME=""
MYSQL_COMMAND=mysql
MYSQLDUMP_COMMAND=mysqldump

while [ "$#" != 0 ] ; do
  case "$1" in
    --host)
      shift
      DB_HOST="$1"
      shift
      ;;
    --database)
      shift
      DB_NAME="$1"
      shift
      ;;
    --mysql-command)
      shift
      MYSQL_COMMAND="$1"
      shift
      ;;
    --mysqldump-command)
      shift
      MYSQLDUMP_COMMAND="$1"
      shift
      ;;
    *)
      syntaxErrorFailExit "Неизвестный аргумент $1"
      ;;
  esac
done

[ -z "$DB_NAME" ] && syntaxErrorFailExit "Не указана БД"
[ -z "$DB_HOST" ] && syntaxErrorFailExit "Не указан хост"

assertOutputRedirected

msg "Проверка подключения к $DB_HOST"

if ! ssh "$DB_HOST" true ; then
	errorFailExit "Не настроено соединение с площадкой $DB_HOST Необходимо включить ForwardAgent yes в настройках подключения к площадке $DB_HOST по ssh."
fi

msg "Проверка доступа к БД $DB_NAME"

ssh "$DB_HOST" "$MYSQL_COMMAND -e 'show tables' '$DB_NAME' > /dev/null" || {
	errorMsg "Не удалось подключиться к БД $DB_NAME на площадке $DB_HOST. Проверьте настройки подключения в файле ~/.my.cnf на площадке $DB_HOST или уточните параметры --mysql-command"
	msg ""
	msg "Список БД на $DB_HOST:"
  ssh "$DB_HOST" "$MYSQL_COMMAND -e 'show databases'" >&2 || errorMsg "Список БД также не удалось получить"
	msg ""
	exit 1
}

msg "Получение дампа..."
msg "Сообщения вида 'mysqldump: Error: 'Access denied; you need (at least one of) the PROCESS privilege(s)' не являются ошибкой."
msg ""

ssh "$DB_HOST" "set -eu -o pipefail ; $MYSQLDUMP_COMMAND '$DB_NAME' | gzip" || {
	errorFailExit "Произошла ошибка при получении дампа БД $DB_NAME с $DB_HOST"
}


