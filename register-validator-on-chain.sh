#!/bin/bash

docker-compose run build-env bash -c '(cd casper-node; make build-client-contracts; cp -R /casper-node/target/wasm32-unknown-unknown/release/ /build/)'

export PUBKEYHEX=$(cat etc/casper/validator_keys/public_key_hex)

docker-compose exec casper-node casper-client put-deploy --chain-name casper-delta-1 --node-address http://18.144.69.216:7777/ --secret-key /etc/casper/validator_keys/secret_key.pem --session-path  /contracts/release/add_bid.wasm  --payment-amount 10000000000  --session-arg=public_key:"public_key='$PUBKEYHEX'" --session-arg=amount:"u512='1000009'" --session-arg=delegation_rate:"u64='10'"
