#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ "$#" -ne 2 ]
then
  echo "ERROR: Incorrect number of arguments"
  echo "Usage: _build_app.sh APP TAG (e.g. '_build_app.sh front 0.1.0')"
  exit 1
fi

APP=$1
TAG=$2

IMAGE=vitaliby/appname-$APP

JAR_PATH=$SCRIPT_DIR/../app/$APP/build/libs
DOCKERFILE_PATH=$SCRIPT_DIR/../app/$APP/src/main/docker/Dockerfile

docker build -t $IMAGE:$TAG $JAR_PATH -f $DOCKERFILE_PATH
docker push $IMAGE:$TAG