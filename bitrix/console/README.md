# Инструкция

1. Скопировать `console.php` и `apps/` в корень проекта (не сайта).
2. В `console.php` поправить настройки в блоке НАСТРОЙКИ.
3. Разместить в apps/console/scripts свои скрипты.
4. Запускать скрипты с помощью `console.php имя_скрипта`
  * В имени скрипта не нужно указывать `apps/console/scripts` и расширение `.php`.
  * В скрипте не нужно инициализировать Битрикс - он будет уже проинициализирован в `console.php`

Скрипт `apps/console/scripts/do-smth.php` будет запускаться с помощью

```
console.php do-smth
```

Скрипт `apps/console/scripts/tools/do-smth.php` будет запускаться с помощью

```
console.php tools/do-smth
```

