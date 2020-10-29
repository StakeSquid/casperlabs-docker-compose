#!/bin/bash

git checkout etc/casper/config.toml
git pull

echo "[network] 
public_address='$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short):34553'" | crudini --merge etc/casper/config.toml
echo "[node] 
trusted_hash='01b86c7851bb9bbb2c5e160ed731561752093e8817a0b092c5ebc5002be3b8d4'" | crudini --merge etc/casper/config.toml

docker-compose up -d --build --force-recreate