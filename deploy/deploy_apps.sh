#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

apps=("back" "reader" "front")

for app in ${apps[@]}; do
  echo "## Deploying $app"
  
  HELM_RELEASE=$app
  NAMESPACE=demo-$app
  HELM_CHART_PATH=$SCRIPT_DIR/../helm/$app

  ${SCRIPT_DIR}/_deploy_app.sh $HELM_RELEASE $NAMESPACE $HELM_CHART_PATH
done