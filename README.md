Setup
=====

```
apt update -y && apt install -y dnsutils docker-compose docker.io jq crudini git
git clone https://github.com/StakeSquid/casperlabs-docker-compose.git
cd casperlabs-docker-compose
./update.sh

```

Now you can edit the generated validator identity key files in etc/casper/validator_keys/ to set them to the ones you already have registered before or send in the content of the file etc/casper/validator_keys/public_key_hex to register the new keypair for a genesis validator slot.

```
./update.sh
```

This refreshed the installation and restarts the node with the updated keys.

Get your current public key hex to submit it to receive testnet coins for bonding with the collowing command.

```
cat etc/casper/validator_keys/public_key_hex
```

Faucet
######

You can upload the public key to the web wallet and find the [faucet](https://testnet-explorer.casperlabs.io/#/faucet) in the left menu bar to receive some coins.

```
cat etc/casper/validator_keys/public_key.pem
```


Bonf the validator
##################

Once your account is funded and you want to start validating it is required to bid in the auction contract to register your public key hex for a validator slot.

```
./register-validator-on-chain.sh
```

Note: The script bids a fixed amount that can be changed in the script.

```
--payment-amount 1000000000000
```

Some commands
#############

```
docker-compose exec casper-node casper-client get-deploy --node-address http://3.137.146.20:7777 3e2b0f33aa633c01a8cb46684cb6b6bd66a6c2d5a5718e2cea46e200747487dc
```

```
docker-compose exec casper-node wget -qO - http://127.0.0.1:7777/status | jq .peers
```

