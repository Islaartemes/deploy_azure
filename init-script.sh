#!/bin/bash

# Atualiza pacotes
sudo apt-get update -y

# Instala Docker e Docker Compose
sudo apt-get install -y docker.io docker-compose

# Adiciona o usuário atual ao grupo docker para evitar usar 'sudo' com Docker
sudo usermod -aG docker $(whoami)

# Define o diretório home do usuário
USER_HOME="/home/$(whoami)"

# Cria o arquivo docker-compose.yml com o conteúdo necessário
cat <<EOF > $USER_HOME/docker-compose.yml
version: '3.7'

services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: GAud4mZby8F3SD6P
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress

  wordpress:
    build: .
    ports:
      - "80:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    depends_on:
      - db

volumes:
  db_data:
EOF

# Cria o arquivo Dockerfile com o conteúdo necessário
cat <<EOF > $USER_HOME/Dockerfile
# Use uma imagem base do WordPress
FROM wordpress:latest

# Copie o arquivo de configuração do WordPress para dentro do contêiner
COPY ./wp-config.php /var/www/html/wp-config.php
EOF

# Altera a propriedade dos arquivos
sudo chown $(whoami):$(whoami) $USER_HOME/docker-compose.yml
sudo chown $(whoami):$(whoami) $USER_HOME/Dockerfile

# Navega para o diretório home e inicializa o Docker Compose
cd $USER_HOME
docker-compose up -d

# Verifica se Docker está instalado corretamente
docker --version
docker-compose --version
