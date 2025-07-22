#!/bin/bash

exec > /var/log/user-data.log 2>&1

echo ">>> Updating packages"
apt-get update -y

echo ">>> Installing Docker"
apt-get install -y docker.io

echo ">>> Starting Docker service"
systemctl start docker
systemctl enable docker

echo ">>> Pulling Strapi Docker image"
docker pull brohan9/strapi-app=${docker_tag}

echo ">>> Removing old Strapi container if exists"
docker rm -f strapi || true

echo ">>> Running Strapi container"
docker run -d \
  --name strapi \
  -p 1337:1337 \
  --restart unless-stopped \
  brohan9/strapi-app=${docker_tag}

echo ">>> Done setting up Strapi"

