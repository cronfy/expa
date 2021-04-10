# PHP

## Разница между `@$x ?: 'abc'` `$x ?? 'abc'`

```php
$a = ['f' => false, 't' => true];

$a['t'] ?? 'abc'; // true
$a['f'] ?? 'abc'; // false
$a['n'] ?? 'abc'; // 'abc'

@$a['t'] ?: 'abc'; // true
@$a['f'] ?: 'abc'; // abc
@$a['n'] ?: 'abc'; // abc
```
