# json_encode() с часто используемыми флагами

```php
    /**
     * json_encode() с часто используемыми флагами
     *
     * @param array|string $data
     * @return string
     */
    public static function encode($data): string
    {
        return json_encode($data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }
```