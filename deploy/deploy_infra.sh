#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INFRA_ROOT_PATH=$SCRIPT_DIR/../infra

## Deploy Postgres
bash $INFRA_ROOT_PATH/postgresql/install.sh

## Deploy Kafka
bash $INFRA_ROOT_PATH/kafka/install.sh