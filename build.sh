#!/bin/bash

# This script builds a new container with Juju installed inside.

set -ex

# Add the linuxcontainers image repository.
lxc remote add linuxcontainers images.linuxcontainers.org
# Pull a clean image from the repository.
lxc launch linuxcontainers:ubuntu/xenial/amd64 juju-container

lxc list

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

lxc file push cleanup.sh juju-container/home/ubuntu/
lxc exec juju-container -- /home/ubuntu/cleanup.sh
lxc exec juju-container -- rm /home/ubuntu/cleanup.sh
