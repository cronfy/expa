# Динамическое определение document root для Битрикса (удобно для консольных скриптов)

Ищет document root, поднимаясь от заданной директории выше, пока не найдет. 

Первый аргумент ф-ии - директория, от которой начинать поиск. Второй - массив названий файлов, директорий, по наличию которых и определяется, что это document root. Document root - это папка, в которой присутствуют **все** указанные файлы/директории. 

```php
<?php

$_SERVER["DOCUMENT_ROOT"] = (function (string $startDir, array $mustHaveEntries) {
    $dir = $startDir;
    do {
        $haveAll = true;
        foreach ($mustHaveEntries as $entry) {
            if (!file_exists($dir . '/' . $entry)) {
                $haveAll = false;
                break;
            }
        }

        if ($haveAll) {
            return realpath($dir);
        }

        $prevDir = $dir;
        $dir = dirname($dir);
        if ($dir === $prevDir) {
            throw new \Exception("Не удалось найти document root. Разместите скрипт внутри корня сайта.");
        }
    } while (true);
})(__DIR__, ['bitrix', 'vendor']);
```
