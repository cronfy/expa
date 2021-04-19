# PHP отдает статус 200 (а не 500) на Exception, когда включен `display_errors`

Пруф: https://bugs.php.net/bug.php?id=50921

Workaround:

```php
register_shutdown_function( "fatal_handler" );
function fatal_handler() {
    http_response_code (500);
}

throw new \Exception('oh my');
```