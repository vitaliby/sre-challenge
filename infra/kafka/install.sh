#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NAMESPACE=kafka

## Kafka
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install kafka bitnami/kafka --namespace $NAMESPACE --create-namespace -f $SCRIPT_DIR/values.yaml