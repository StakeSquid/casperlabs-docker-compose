#!/bin/bash

git checkout etc/casper/config.toml
git pull

echo "[network] 
public_address='$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short):34553'" | crudini --merge etc/casper/config.toml
echo "[node] 
trusted_hash='0e41a5edf2e2abb4f82fe829e939f16f3da70022c0ef56e50ecaadb9fbb237f8'" | crudini --merge etc/casper/config.toml

docker-compose up -d --build --force-recreate
