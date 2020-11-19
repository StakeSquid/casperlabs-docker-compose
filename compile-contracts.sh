#!/bin/bash

#docker-compose build build-env

docker-compose run build-env bash -c '(cd casper-node; make build-client-contracts; cp -R /casper-node/target/wasm32-unknown-unknown/release/ /build/)'
