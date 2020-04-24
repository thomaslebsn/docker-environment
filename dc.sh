#!/usr/bin/env bash

docker stop THIENLD-VSRV
docker rm THIENLD-VSRV
docker-compose run --service-ports --name THIENLD-VSRV workspace
