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
