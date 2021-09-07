# php session time extend: htaccess, php

```php
// время жизни сессий одна неделя
ini_set('session.gc_maxlifetime', 604800);
ini_set('session.cookie_lifetime', 604800);
```

```apacheconf
# время жизни сессий одна неделя
php_value session.gc_maxlifetime 604800
php_value session.cookie_lifetime 604800
```
