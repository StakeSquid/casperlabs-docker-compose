#!/bin/bash

# delete the db by removing the named volume
docker-compose down -v

# update and restart
./update.sh
