# DevDenv: Dev Docker Environment

## Решение проблем с конфигами

Спасибо https://stackoverflow.com/a/50166314/1775065

```
docker cp container_web_1:/etc/apache2/conf-enabled/some-settings.conf .
# ... edit some-settings.conf ...
docker cp some-settings.conf container_web_1:/etc/apache2/conf-enabled/some-settings.conf
```

