# console queries

.my.cnf - подходит и для mysql, и для mysqldump

```bash
[client]
user=someuser
host=127.0.0.1
password="somepassword"

[mysql]
database=somedatabase

```

```bash
mysql --defaults-extra-file=./.my.cnf -B -N -e 'show tables'

mysql --defaults-extra-file=./.my.cnf -B -N -e 'show tables'| while read table ; do mysql --defaults-extra-file=./.my.cnf -e "show create table \`$table\`" ; done
```


