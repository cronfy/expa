<?php

$files = glob(__DIR__ . "/lib/{,*/,*/*/,*/*/*/}*.php", GLOB_BRACE);

$prefixLength = strlen(__DIR__ . '/lib/');
$classes = [];
foreach ($files as $file) {
    $classPath = substr(substr($file, $prefixLength), 0, -4);
    $includePath = "lib/$classPath.php";
    $namespacePath = strtr($classPath, '/', '\\');
    $className = "itweb\\local\\$namespacePath";

    $classes[$className] = $includePath;
}

Bitrix\Main\Loader::registerAutoloadClasses('itweb.local', $classes);

