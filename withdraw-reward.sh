#!/bin/bash

# reward withdraw

# Requirements: DELTA 3 master branch contracts ('make build-contracts-rs release')
# Requirements: 'apt install jq'
# Requirements: 'path to smart contract` and 'validator public hex` below

VALIDATOR_PUB_HEX=$(cat etc/casper/validator_keys/public_key_hex)

withdraw_validator_reward_contract="/contracts/release/withdraw_validator_reward.wasm"

API='http://localhost:7777' # set to another point if necessary

CHAIN_NAME='casper-delta-3'

# ------------------------------------------------------------------------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

function CheckBalance() {

  LFB=$(curl -s http://127.0.0.1:7777/status | jq -r '.last_added_block_info | .height')

  LFB_ROOT=$(docker-compose exec casper-node casper-client get-block --node-address http://localhost:7777 -b "$LFB" | jq -r '.result | .block | .header | .state_root_hash')

  PURSE_UREF=$(docker-compose exec casper-node casper-client query-state --node-address http://localhost:7777 -k "$VALIDATOR_PUB_HEX" -s "$LFB_ROOT" | jq -r '.result | .stored_value | .Account | .main_purse')

  BALANCE=$(docker-compose exec casper-node casper-client get-balance --node-address http://localhost:7777 --purse-uref "$PURSE_UREF" --state-root-hash "$LFB_ROOT" | jq -r '.result | .balance_value')

}

function Broadcast() {

  echo && echo -e "Deploying withdrawal transaction ..." && echo

  TX=$(docker-compose exec casper-node casper-client put-deploy \
    --chain-name "$CHAIN_NAME" \
    --node-address http://localhost:7777 \
    -k /etc/casper/validator_keys/secret_key.pem \
    --session-path "$withdraw_validator_reward_contract" \
    --payment-amount 1000000000 \
    --session-arg "validator_public_key:public_key='$VALIDATOR_PUB_HEX'" \
    --session-arg "target_purse:opt_uref=null" | jq -r '.result | .deploy_hash')

  echo -e "${CYAN}Transaction ID:${NC} ${GREEN}$TX${NC}" && sleep 5 &&echo

}

function WatchPassTrough() {

  echo -e "Waiting for confirmation ..." && echo

  start=$(date +%s.%N)

  while true; do

    i=1
    sp="▉"
    echo -n ' '
    printf "\b${sp:i++%${#sp}:1}"

    BlockHash="$(docker-compose exec casper-node casper-client get-deploy --node-address http://127.0.0.1:7777 $TX | jq -r '.result | .execution_results | .[] | .block_hash')"

    if [[ "${#BlockHash}" -eq 64 ]]; then

      duration=$(echo "$(date +%s.%N) - $start" | bc)
      execution_time=$(printf "%.2f seconds" "$duration")

      echo && echo && echo -e "${CYAN}Confirmed in${NC} $execution_time ${CYAN}seconds, block hash: ${GREEN}$BlockHash${NC}" && echo

      break

    fi

    sleep 1

  done

}

function CheckTX() {

  echo -e "Query transaction data ..." && echo

  docker-compose exec casper-node casper-client get-deploy --node-address http://127.0.0.1:7777 "$TX" | jq 'del(.result.deploy.session.ModuleBytes.module_bytes)'

}

CheckBalance

START_BALANCE="$BALANCE"

Broadcast

WatchPassTrough

CheckTX

CheckBalance

# RETURN=$(echo "$BALANCE - $START_BALANCE" | bc -l)

echo && echo -e "${CYAN}Input initial balance: ${GREEN}$START_BALANCE${NC}"

echo -e "${CYAN}Input current balance: ${GREEN}$BALANCE${NC}" && echo

# echo -e "${GREEN}Withdraw amount: $RETURN" && echo
