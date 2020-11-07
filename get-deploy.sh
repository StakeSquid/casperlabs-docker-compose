#!/bin/bash

docker-compose exec casper-node casper-client get-deploy $1 --node-address http://18.144.69.216:7777
