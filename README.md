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

Get your current public key hex with the collowing command.

```
cat etc/casper/validator_keys/public_key_hex
```

Once your account is funded and you want to start validating it is required to bid in the auction contract to register your public key hex for a validator slot.

```
./register-validator-on-chain.sh
```

Note: The script bids a fixed amount that can be changed in the script.

```
--payment-amount 1000000000000
```


