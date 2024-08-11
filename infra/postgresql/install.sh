#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NAMESPACE=postgres

## Postgresql
kubectl create ns $NAMESPACE

kubectl -n $NAMESPACE create secret generic postgresql-creds  \
--from-literal admin-password='PjrmCFfRzpw8hLCmL93jS9BK' \
--from-literal appuser-password='khPyBl7lA6Ap4JmzWOpG9S8v'

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install postgresql bitnami/postgresql --namespace $NAMESPACE --create-namespace -f $SCRIPT_DIR/values.yaml
