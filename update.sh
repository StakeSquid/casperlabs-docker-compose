#!/bin/bash

git checkout etc/casper/config.toml
git pull

printf "\n\npublic_address = '$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short):34553'" >> etc/casper/config.toml
printf "\ntrusted_hash = $(curl -s 54.177.84.9:7777/status | jq .genesis_root_hash)" >> etc/casper/config.toml

docker-compose up --build --force-recreate