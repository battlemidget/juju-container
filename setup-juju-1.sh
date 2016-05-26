#!/bin/bash

# This script runs on the LXC image as root to install and configure Juju-1.
# When a user is passed as an argument, the user must already be created.

set -ex

# When there are not enough arguments default to the ubuntu user.
if [ "$#" -lt 1 ]; then
  USER=ubuntu
else
  USER=$1
fi

apt-get update -qq --fix-missing
# Install tools like add-apt-repository
apt-get install -qy software-properties-common
# The stable ppa is required for charm-tools.
apt-add-repository -y ppa:juju/stable
apt-get update -qq --fix-missing

INSTALL_PACKAGES=(juju-core charm-tools byobu vim tree openssh-client \
  virtualenvwrapper python-dev cython git)

apt-get -qy install ${INSTALL_PACKAGES[*]}

HOME=/home/${USER}
# Set up the Juju environment variables for the user.
RC=${HOME}/.bashrc
# JUJU_HOME is the path to Juju's configuration files.
echo "export JUJU_HOME=${HOME}/.juju" >> $RC
# JUJU_REPOSITORY is the directory to look for charms.
echo "export JUJU_REPOSITORY=${HOME}/charms" >> $RC
JUJU_VERSION=$(juju-1 version)
echo "echo 'welcome to $JUJU_VERSION'" >> $RC
# Create the Juju charm directories so they can be mounted in other steps.
mkdir -p ${HOME}/charms
mkdir ${HOME}/charms/precise
mkdir ${HOME}/charms/trusty
mkdir ${HOME}/charms/xenial

chown -R ${USER}:${USER} ${HOME}

# Remove uneeded packages.
REMOVE_PACKAGES=(cython gcc git perl)

apt-get remove -qy ${REMOVE_PACKAGES}

apt-get autoremove -qy
apt-get autoclean -qy
apt-get clean -qy
