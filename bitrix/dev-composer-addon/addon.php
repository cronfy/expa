<?php

use Symfony\Component\VarDumper\VarDumper;

require_once __DIR__ . '/vendor/autoload.php';

if (!function_exists('dump')) {
    /**
     * @author Nicolas Grekas <p@tchwork.com>
     */
    function dump($var, ...$moreVars)
    {
        VarDumper::dump($var);

        foreach ($moreVars as $v) {
            VarDumper::dump($v);
        }

        if (1 < func_num_args()) {
            return func_get_args();
        }

        return $var;
    }
}

if (!function_exists('dd')) {
    function dd(...$vars)
    {
        foreach ($vars as $v) {
            VarDumper::dump($v);
        }

        die(1);
    }
}

function DJ(...$vars) {
    global $APPLICATION;

    $APPLICATION->EndBufferContent();
    while (ob_get_level()) {
        ob_end_flush();
    }

    $backtrace = debug_backtrace();
    $caller = $backtrace[0];
    $file = @$caller['file'];
    $line = @$caller['line'];

    $message = DJ_format_message($file, $line);

    echo $message;

    register_shutdown_function(function () use ($message) {
        echo $message;
    });

    dd(...$vars);
}

function DJ_format_message($file, $line) {
    if (php_sapi_name() === 'cli') {
        $message = "\n\nDebug in {$file} line {$line}\n\n";
    } else {
        $message = "\n<br>\nDebug in {$file} line {$line}\n<br>\n";
    }

    return $message;
}


