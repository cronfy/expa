# docker

## Установка docker на Linux Mint 20

По инструкции https://docs.docker.com/engine/install/ubuntu/

```
sudo apt-get remove docker docker.io containerd runc docker-compose

sudo apt-get remove docker docker.io containerd runc docker-compose
sudo apt-get update
sudo apt-get install     apt-transport-https     ca-certificates     curl     gnupg     lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  focal stable" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# user

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker # вместо ребута, чтобы проверить, но потом все равно нужен ребут
docker run hello-world

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# reboot
```
