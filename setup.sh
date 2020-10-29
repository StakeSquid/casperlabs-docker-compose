#!/bin/bash
apt update -y
apt install dnsutils docker-compose docker.io jq

./update.sh
