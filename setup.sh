#!/bin/bash
apt update -y
apt install dnsutils docker-compose docker.io jq crudini

./update.sh
