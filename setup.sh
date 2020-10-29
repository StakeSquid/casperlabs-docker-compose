#!/bin/bash
apt update -y
apt install dnsutils

echo "\n\npublic_address = '$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short):34553'" >> etc/casper/config.toml
