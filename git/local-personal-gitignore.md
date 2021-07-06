## local personal gitignore rules

Правила gitignore, которые являются локальными, персональными и не коммитятся в проект.

Например, чтобы исключить свой dockerfile, свои тулзы и пр.

В `.git/config`:

```
[core]
#        ...
    excludesfile = dev-cronfy/git/.local_gitignore
#        можно даже вне репозитория, например:
#    excludesfile = ../dev-cronfy/git/.local_gitignore
```

В `dev-cronfy/git/.local_gitignore`:

```gitignore
/dev-cronfy
# ...
```

