#!/usr/bin/env php
<?php
/**
 * Шаблон консольного скрипта.
 *
 * 1. Поправь НАСТРОЙКИ.
 * 2. Пропиши ЛОГИКУ.
 * 3. Скрипт готов.
 */

// просто для того, чтобы был namespace, чтобы случайно не пересечься
// с существующими ф-ями
namespace console;


/*
 * НАСТРОЙКИ
 */

// ПРОПИСАТЬ корректный путь до document root
// (в консоли $_SERVER["DOCUMENT_ROOT"] не установлен, нужно установить руками)
$documentRoot = $_SERVER["DOCUMENT_ROOT"] = __DIR__ . '/public_html';







/*
 * ИНИЦИАЛИЗАЦИЯ консольного скрипта
 */
function stdErr($msg) {
    fwrite(STDERR, "$msg\n");
}

function stdOut($msg) {
    fwrite(STDOUT, "$msg\n");
}

if (ini_get('mbstring.func_overload') !== "2") {
    stdErr('mbstring.func_overload должен быть равен 2. Некорректные настройки php. Выходим.');
    die();
}

if (ini_get('mbstring.internal_encoding') !== "UTF-8") {
    stdErr('mbstring.internal_encoding должен быть равен UTF-8. Некорректные настройки php. Выходим.');
    die();
}


define("NO_KEEP_STATISTIC", true);
define("NOT_CHECK_PERMISSIONS",true);
define('CHK_EVENT', true);
define('BX_NO_ACCELERATOR_RESET', true);
// для отключения буферов, см. [1]
define("BX_BUFFER_USED", true);

require($documentRoot . "/bitrix/modules/main/include/prolog_before.php");

// [1]
// отключаем буферы, как написано тут
// https://dev.1c-bitrix.ru/community/webdev/user/5593/blog/otklyuchaem-buferizatsiyu-v-konsolnykh-skriptakh-bitriksa/
while (ob_get_level()) {
    ob_end_flush();
}

set_time_limit(0);

// конец инициализации






/*
 * ЛОГИКА
 */

// РАЗБОР параметров командной строки

$arg1 = @$argv[1];

// РАБОТА

if (!$arg1) {
    stdErr("Syntax: " . basename(__FILE__) . ' command/to/execute');
    exit(1);
}

$script = __DIR__ . '/apps/console/scripts/' . $arg1 . '.php';

if (!file_exists($script)) {
    stdErr("Script not found");
    exit(1);
}

// чтобы в скрипте можно было естественным образом получать аргументы (отрезаем сам console.php)
array_shift($argv);

require $script;
