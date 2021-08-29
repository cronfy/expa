
echo "
COMPOSE_FILE=\"$ENV_COMPOSE_FILE\"

SERVICES_PATH=\"$ENV_SERVICES_DIR\"

RUN_AS_UID=\"$ENV_USER_UID\"
RUN_AS_GID=\"$ENV_USER_GID\"

# первые *три* октета для выделения IP сервисам в проекте
BASE_NET=172.10.1
BASE_NET_MASK=24

"

