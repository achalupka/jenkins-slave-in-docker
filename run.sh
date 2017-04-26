#!/bin/bash
set -e
cd `dirname $0`
cp /etc/ssh/authorized-keys/jenkins.pub .

export DOCKER_GID=`getent group docker | cut -d ':' -f 3`

docker-compose build jenkins-slave
docker-compose up -d jenkins-slave 
#docker-compose run --rm --service-ports jenkins-slave /bin/sh
