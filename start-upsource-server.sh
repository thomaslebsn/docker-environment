#!/usr/bin/env bash

mkdir -p ./upsource-storage/data
mkdir -p ./upsource-storage/logs
mkdir -p ./upsource-storage/conf
mkdir -p ./upsource-storage/backups

# sudo chmod -R 750 ./upsource-storage/data
# sudo chmod -R 750 ./upsource-storage/logs
# sudo chmod -R 750 ./upsource-storage/conf
# sudo chmod -R 750 ./upsource-storage/backups

# sudo chown -R 13001:13001 ./upsource-storage/data
# sudo chown -R 13001:13001 ./upsource-storage/logs
# sudo chown -R 13001:13001 ./upsource-storage/conf
# sudo chown -R 13001:13001 ./upsource-storage/backups

CUR_DIR=$(pwd)
UPSOURCE_DATA_DIR=$CUR_DIR/upsource-storage/data
UPSOURCE_CONF_DIR=$CUR_DIR/upsource-storage/conf
UPSOURCE_LOGS_DIR=$CUR_DIR/upsource-storage/logs
UPSOURCE_BACKUPS_DIR=$CUR_DIR/upsource-storage/backups

docker stop upsource-server-instance
docker rm upsource-server-instance
docker run -it --name upsource-server-instance -v $UPSOURCE_DATA_DIR:/opt/upsource/data \
-v $UPSOURCE_CONF_DIR:/opt/upsource/conf \
-v $UPSOURCE_LOGS_DIR:/opt/upsource/logs \
-v $UPSOURCE_BACKUPS_DIR:/opt/upsource/backups \
-p 8080:8080 jetbrains/upsource:2020.1.1815
