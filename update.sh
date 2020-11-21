#!/bin/bash

git checkout etc/casper/config.toml
git pull

TRUSTED_NODE=54.67.67.33
TRUSTED_HASH=$(curl -s http://$TRUSTED_NODE:7777/status | jq -r '.last_added_block_info | .hash')

echo "trusted hash is $TRUSTED_HASH\n"

crudini --set etc/casper/config.toml "network" "public_address" "'$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short):35000'"

if [ -z "$TRUSTED_HASH" ]
then
	crudini --del etc/casper/config.toml "node" "trusted_hash"
else
	crudini --set etc/casper/config.toml "node" "trusted_hash" "'${TRUSTED_HASH}'"    
fi

docker-compose up -d --build --force-recreate
