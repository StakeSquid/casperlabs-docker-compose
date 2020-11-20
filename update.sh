#!/bin/bash

git checkout etc/casper/config.toml
git pull

TRUSTED_HASH=$(curl -s http://54.177.84.9:7777/status | jq -r '.last_added_block_info | .hash')

echo "[network] 
public_address='$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short):34553'" | crudini --merge etc/casper/config.toml
echo "[node] 
trusted_hash='${TRUSTED_HASH:-null}'" | crudini --merge etc/casper/config.toml

docker-compose up -d --build --force-recreate
