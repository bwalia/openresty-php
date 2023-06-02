#!/usr/bin/env bash
# -- Author: Balinder Walia --
# -- Pushes the docker image : openresty119php74 into AWS ECR / or optionally into a given Docker registry --
# -- $1 is mandatory image version, for example : latest --

set -x

# VERSION=$1
# AWS_PROFILE_NAME=$2
# REGION=$3

# if [ -z ${VERSION} ];
# then
#   echo "openresty-php docker image version not set"
#   exit 1
# fi

docker build -f devops/docker/Dockerfile -t openresty-php .
docker tag openresty-php:latest registry.workstation.co.uk/openresty-php:latest
docker push registry.workstation.co.uk/openresty-php:latest

# Push to docker public registry as well
docker tag openresty-php:latest bwalia/openresty-php:latest && docker push bwalia/openresty-php:latest