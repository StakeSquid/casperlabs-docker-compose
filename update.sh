#!/bin/bash

git checkout etc/casper/config.toml
git pull

echo "
[agent]
public_address='$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short):34553'
trusted_hash=$(curl -s 54.177.84.9:7777/status | jq .genesis_root_hash)" |

crudini --merge etc/casper/config.toml

docker-compose up --build --force-recreate