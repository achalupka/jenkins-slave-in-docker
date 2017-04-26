# Jenkins slave

## Prerequisites

- docker daemon 17.04 listening to /var/run/docker.sock
- docker group 
- docker-compose 1.12
- jenkins master setup with public key available

## Run

Put public key to `/etc/ssh/authorized-keys/jenkins.pub`

```
sudo ./run.sh
```

## Test

Go to jenkins master:

```
ssh -i ~/.ssh/id_rsa -p 9022 jenkins-slave@hostname
```

## How it works

Jenkins slave is basically an ssh daemon with java and docker-compose

Jenkins master will login to jenkins slave copy and ran jenkins.jar file which will connect to jenkins master.



