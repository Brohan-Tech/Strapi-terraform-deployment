#!/bin/bash

exec > /var/log/user-data.log 2>&1

echo ">>> Updating packages"
sudo apt-get update -y

echo ">>> Installing Docker"
sudo apt-get install -y docker.io

echo ">>> Starting Docker service"
sudo systemctl start docker
sudo systemctl enable docker

echo ">>> Pulling Strapi Docker image"
sudo docker pull brohan9/strapi-app=${docker_tag}

echo ">>> Removing old Strapi container if exists"
sudo docker rm -f strapi || true

echo ">>> Running Strapi container with APP_KEYS"
sudo docker run -d \
  --name strapi \
  -p 1337:1337 \
  --restart unless-stopped \
  -e APP_KEYS="myKeyA,myKeyB" \
  brohan9/strapi-app=${docker_tag}

echo ">>> Done setting up Strapi"

