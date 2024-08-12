#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INFRA_ROOT_PATH=$SCRIPT_DIR/../infra

echo "## Deploying Postgres"
bash $INFRA_ROOT_PATH/postgresql/install.sh

echo "## Deploying Kafka"
echo "## Be patient, it takes some time..."
bash $INFRA_ROOT_PATH/kafka/install.sh