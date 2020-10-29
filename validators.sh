#!/bin/bash

declare -a TrustedValidators=("54.177.84.9" "18.144.69.216" "13.57.251.65")

for validator_ip in "${!TrustedValidators[@]}";
        do
                curl -s http://"${TrustedValidators[$validator_ip]}":7777/status | jq .last_added_block_info
        done