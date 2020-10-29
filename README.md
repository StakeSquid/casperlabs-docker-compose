Purpose
=======

This repository installs a casper-node for participation in the Charlie testnet.

Server
======

Please run this script on a CPX41 VPS from [Hetzner cloud](https://hetzner.cloud/?ref=uqph3EQTVIIR) which costs €22,90 per month.

Setup
======

```
git clone https://github.com/StakeSquid/casperlabs-docker-compose.git
cd casperlabs-docker-compose
./setup.sh
```

Now you can edit the generated validator identity key files in etc/casper/validator_keys/ to set them to the ones you already have registered before or send in the content of the file etc/casper/validator_keys/public_key_hex to register the new keypair for a genesis validator slot.

```
./update.sh
```

This refreshed the installation and restarts the node with the updated keys.



