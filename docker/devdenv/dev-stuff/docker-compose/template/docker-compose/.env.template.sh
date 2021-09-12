
echo "
COMPOSE_FILE=\"$ENV__COMPOSE_FILE\"

SERVICES_PATH=\"$ENV__SERVICES_DIR\"

RUN_AS_UID=\"$ENV__USER_UID\"
RUN_AS_GID=\"$ENV__USER_GID\"

# первые *три* октета для выделения IP сервисам в проекте
BASE_NET=172.10.1
BASE_NET_MASK=24

"

