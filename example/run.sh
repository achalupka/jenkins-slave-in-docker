#!/bin/bash
set -e
cd `dirname $0`

export DOCKER_GID=`getent group docker | cut -d ':' -f 3`
docker stack deploy -c deploy.yml jenkins
