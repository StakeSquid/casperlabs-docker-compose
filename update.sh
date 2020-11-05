#!/bin/bash

git checkout etc/casper/config.toml
git pull

echo "[network] 
public_address='$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short):34553'" | crudini --merge etc/casper/config.toml
echo "[node] 
trusted_hash='122308bc6b6a3630038ba51dca9d7326bdd49989d95af9347d175db10e8f3399'" | crudini --merge etc/casper/config.toml

docker-compose up -d --build --force-recreate