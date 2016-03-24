#!/bin/bash

# This script runs on the LXC image to install and configure Juju.

set -ex

# Sleep a few seconds to let the network come up.
sleep 3

# Install tools like add-apt-repository
apt-get install -qy software-properties-common
# The stable ppa is required for charm-tools.
apt-add-repository -y ppa:juju/stable
apt-get update -qq --fix-missing

apt-get install -qy juju charm-tools byobu vim tree openssh-client \
  virtualenvwrapper python-dev cython git

# Ubuntu user exists in the LXC images, no need to create the user.

HOME=/home/ubuntu
# Set up the Juju environment variables for the Ubuntu user.
RC=${HOME}/.bashrc
echo "export JUJU_HOME=${HOME}/.juju" >> $RC
echo "export JUJU_REPOSITORY=${HOME}" >> $RC
JUJU_VERSION=$(juju version)
echo "echo 'welcome to $JUJU_VERSION'" >> $RC

chown -R ubuntu:ubuntu ${HOME}
