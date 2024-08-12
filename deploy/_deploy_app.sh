#!/bin/bash

if [ "$#" -ne 3 ]
then
  echo "ERROR: Incorrect number of arguments"
  echo "Usage: _deploy_app.sh HELM_RELEASE NAMESPACE HELM_CHART_PATH (e.g. '_deploy_app.sh front demo-front ../helm/front')"
  exit 1
fi

HELM_RELEASE=$1
NAMESPACE=$2
HELM_CHART_PATH=$3

helm dependency build $HELM_CHART_PATH

helm install $HELM_RELEASE --namespace $NAMESPACE --create-namespace $HELM_CHART_PATH