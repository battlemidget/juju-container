#!/bin/bash

# Create a new container with Juju installed inside.

set -ex

if [ -z "$1" ]; then
  CODENAME=$(lsb_release -cs)
else
  CODENAME=$1
fi
ARCHITECTURE=$(dpkg --print-architecture)

# Add the linuxcontainers image repository.
lxc remote add linuxcontainers images.linuxcontainers.org

CONTAINER_NAME=juju-container

# Pull a clean image from the repository.
lxc launch linuxcontainers:ubuntu/${CODENAME}/${ARCHITECTURE} ${CONTAINER_NAME}

lxc list

if [ -z ${JUJU_REPOSITORY} ]; then
  echo "No JUJU_REPOSITORY found, please enter your charm directory: "
  read JUJU_REPOSITORY
fi

# Push the setup file and run it, remove the file when complete.
lxc file push setup-juju2.sh ${CONTAINER_NAME}/home/ubuntu/
lxc exec ${CONTAINER_NAME} -- /home/ubuntu/setup-juju2.sh
lxc exec ${CONTAINER_NAME} -- rm /home/ubuntu/setup-juju2.sh

# Mount the devices.
lxc config device add ${CONTAINER_NAME} trusty disk path=/home/ubuntu/trusty \
source=$JUJU_REPOSITORY/trusty
lxc config device add ${CONTAINER_NAME} xenial disk path=/home/ubuntu/xenial \
source=$JUJU_REPOSITORY/xenial
lxc config device add ${CONTAINER_NAME} juju-home disk \
path=/home/ubuntu/.local/share/juju source=$HOME/.local/share/juju

# Push the cleanup file and run it, remove the file when complete.
lxc file push cleanup.sh ${CONTAINER_NAME}/home/ubuntu/
lxc exec ${CONTAINER_NAME} -- /home/ubuntu/cleanup.sh
lxc exec ${CONTAINER_NAME} -- rm /home/ubuntu/cleanup.sh
