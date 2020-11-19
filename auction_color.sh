#!/bin/bash

IPv4_STRING='(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'

LOCAL_HTTP_PORT='7777' # if any
API='127.0.0.1'

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m'

function Auction() {

        ActiveValidatorsNow="0"

        COLUMNS=$(tput cols)
        divider=$(printf "%${COLUMNS}s" " " | tr " " "-")
        width=64

        auction_header="${CYAN}%42s\n${NC}"

        echo && printf "%$width.${width}s" "$divider"
        echo && printf "$auction_header" "VALIDATOR PUBLIC KEY"
        printf "%$width.${width}s\n" "$divider"

        numba='^[0-9]+$'

        read -r -a trustedHosts < <(echo $(cat etc/casper/config.toml | grep 'known_addresses = ' | grep -E -o "$IPv4_STRING"))

        for seed_ip in "${trustedHosts[@]}"; do

                era_current=$(curl -s http://"$seed_ip":"$LOCAL_HTTP_PORT"/status | jq -r '.last_added_block_info | .era_id')

                if [[ "$era_current" =~ $numba ]]; then
                        break
                fi
        done

        if ! [[ "$era_current" =~ $numba ]]; then

                echo -e "${RED}ERROR: Can't get current era from trusted source, exit ...${NC}" && sleep 1 && echo && exit 1
        fi

        ActiveValidatorsList=$(docker-compose exec casper-node casper-client get-auction-info --node-address http://"$API":7777 | jq -r '.result | .era_validators.'\"$era_current\"'' | grep -v "{" | grep -v "}" | cut -c4- | tr -d ':",')

        ValidatrsListSorted=$(echo "$ActiveValidatorsList" | sort -nr -t" " -k2n | tac)

        while read validator; do

                Xbond_amount=$(echo -e "$validator" | cut -d ' ' -f 2)
                XValidator_pub_key=$(echo -e "$validator" | cut -d ' ' -f 1)

                echo -e "${GREEN}$XValidator_pub_key ${YELLOW}$Xbond_amount${NC}"

                ActiveValidatorsNow=$((ActiveValidatorsNow+1))

        done <<<"$ValidatrsListSorted"
        printf "%$width.${width}s" "$divider"

        echo && echo -e "${GREEN}Active validators: ${CYAN}$ActiveValidatorsNow ${GREEN}Active era: ${CYAN}$era_current${NC}"

        printf "%$width.${width}s" "$divider" && echo -e "\\n"

}

Auction
