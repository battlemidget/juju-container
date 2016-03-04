#!/bin/bash

# Create a new container with Juju installed inside.

set -ex

if [ -z $JUJU_REPOSITORY ]; then
  echo "No JUJU_REPOSITORY found, please enter your charm directory: "
  read JUJU_REPOSITORY
fi

# Add the linuxcontainers image repository.
lxc remote add linuxcontainers images.linuxcontainers.org
# Pull a clean image from the repository.
lxc launch linuxcontainers:ubuntu/xenial/amd64 juju-container

lxc list

# Push the setup file and run it, remove the file when complete.
lxc file push setup-juju.sh juju-container/home/ubuntu/
lxc exec juju-container -- /home/ubuntu/setup-juju.sh
lxc exec juju-container -- rm /home/ubuntu/setup-juju.sh

# Mount the devices.
lxc config device add juju-container trusty disk path=/home/ubuntu/trusty \
source=$JUJU_REPOSITORY/trusty
lxc config device add juju-container xenial disk path=/home/ubuntu/xenial \
source=$JUJU_REPOSITORY/xenial
lxc config device add juju-container juju-home disk \
path=/home/ubuntu/.local/share/juju source=$HOME/.local/share/juju

# Push the cleanup file and run it, remove the file when complete.
lxc file push cleanup.sh juju-container/home/ubuntu/
lxc exec juju-container -- /home/ubuntu/cleanup.sh
lxc exec juju-container -- rm /home/ubuntu/cleanup.sh
