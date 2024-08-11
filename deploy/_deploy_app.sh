#!/bin/bash

HELM_RELEASE=$1
NAMESPACE=$2
HELM_CHART_PATH=$3

helm dependency build $HELM_CHART_PATH

helm install $HELM_RELEASE --namespace $NAMESPACE --create-namespace $HELM_CHART_PATH