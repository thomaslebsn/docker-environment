#!/usr/bin/env bash

mkdir -p .localstorage
mkdir -p logs/apache2
if [[ ! -f ".env" ]]; then
    echo "ERROR: .env file does NOT exist. Pls create it from env-example and configurations accordingly"
else
    docker stop LAMP-FULL-DEV
    docker rm LAMP-FULL-DEV
    docker-compose run --service-ports --name LAMP-FULL-DEV workspace
fi
