# Casperlabs 1 click instance for Delta testnet


The docker containers are build using the official debian package releases.

## Setup


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


## Updating


In general it is as easy as running the update script.

```
./update.sh
```

After testnet resets when the network is already running you need to delete all the old state in your setup.

```
docker-compose down --rmi 'all' -v --remove-orphans
./update.sh
```

On testnet resets when you wait for genesis, you will have to remove the line with the trusted_hash from the config file or your node because there is no trusted hash yet. You also should comment out the line in the update script that sets a trusted hash to the config file on every update. When genesis is done you should update the trusted hash in the update script and next time you restart it will be set in the config automatically. 

After removing the trusted_hash line from the config file restart the node.

```
docker-compose down && docker-compose up -d
```

You can check the status of your node by querying the status enpoint. The log tends to not say anything for a while after start.

```
curl localhost:7777/status
```





## Bond the validator


Once your account is funded and you want to start validating it is required to bid in the auction contract to register your public key hex for a validator slot.

```
./register-validator-on-chain.sh
```

Note: The script bids a fixed amount that can be changed in the script.

```
# --payment-amount 1000000000000 # this does somehting I don't know
# --session-arg="amount:u512='1000005'" # this is the actual default bid. pretty small but faucet compatible.
```

You can wait a bit and then check if the validator bonded.

```
cat etc/casper/validator_keys/public_key_hex
./get-auction-info.sh
```

In the last section of the output find your hash. It will be smaller. The first 2 digits are cut and the middle part replaced by dots.

```
# original public key hex is 019304135af2f140a87cb5d34670b45619cd4c005244623dc2ff1b41306b57c0f8 
# search for 9304....c0f8
```


## Some commands


```
docker-compose exec casper-node casper-client get-deploy --node-address http://3.137.146.20:7777 3e2b0f33aa633c01a8cb46684cb6b6bd66a6c2d5a5718e2cea46e200747487dc
```

```
docker-compose exec casper-node wget -qO - http://127.0.0.1:7777/status | jq .peers
```

## References


[Node operator guide](https://docs.google.com/document/d/1YO_WnjPt2sGJgPB1jm_hVDHYULYsjPEAtkiAiY0e3-0/edit#heading=h.iauun81d85na)
