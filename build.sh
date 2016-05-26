#!/bin/bash

# Create a new container with Juju installed inside.

set -ex

if [ -z "$1" ]; then
  CODENAME=$(lsb_release -cs)
else
  CODENAME=$1
fi
if [ -z "$2" ]; then
  USER=ubuntu
else
  USER=$2
fi
ARCHITECTURE=$(dpkg --print-architecture)

CONTAINER_NAME=juju-container
# Add the linuxcontainers image repository.
lxc remote add linuxcontainers images.linuxcontainers.org
# Pull a clean ubuntu image from the image repository.
lxc launch linuxcontainers:ubuntu/${CODENAME}/${ARCHITECTURE} ${CONTAINER_NAME}
# Remove the linuxcontainers image repository.
lxc remote remove linuxcontainers
# Sleep a few seconds to allow the network to start up.
sleep 2
# List the lxc image that was just created.
lxc list
# The LXC images already have an ubuntu user, create any other users.
if [ "${USER}" != "ubuntu" ]; then
  lxc exec ${CONTAINER_NAME} -- useradd -m ${USER} -s /bin/bash
fi
# Push the setup file to the container.
lxc file push setup-juju-2.sh ${CONTAINER_NAME}/home/${USER}/
# Run the file inside the container as root.
lxc exec ${CONTAINER_NAME} -- /home/${USER}/setup-juju-2.sh ${USER}
# Remove the file when complete.
lxc exec ${CONTAINER_NAME} -- rm /home/${USER}/setup-juju-2.sh
# JUJU_REPOSITORY is the location to look for charms.
if [ -z "${JUJU_REPOSITORY}" ]; then
  echo "No JUJU_REPOSITORY found, please enter your charm directory: "
  read JUJU_REPOSITORY
fi
# Map the charm directories to this container.
if [ -d "${JUJU_REPOSITORY}/precise" ]; then
  lxc config device add ${CONTAINER_NAME} precise disk \
  path=/home/${USER}/charms/precise source=${JUJU_REPOSITORY}/precise
fi
if [ -d "${JUJU_REPOSITORY}/trusty" ]; then
  lxc config device add ${CONTAINER_NAME} trusty disk \
  path=/home/${USER}/charms/trusty source=${JUJU_REPOSITORY}/trusty
fi
if [ -d "${JUJU_REPOSITORY}/xenial" ]; then
  lxc config device add ${CONTAINER_NAME} xenial disk \
  path=/home/${USER}/charms/xenial source=${JUJU_REPOSITORY}/xenial
fi
# Map the JUJU_DATA directory to this container.
if [ -d "${JUJU_DATA}" ]; then
  lxc config device add ${CONTAINER_NAME} juju-data disk \
  path=/home/${USER}/.local/share/juju source=${JUJU_DATA}
fi
echo "Build completed successfully."
