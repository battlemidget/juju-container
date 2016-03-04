#!/bin/bash

# This script runs on the LXC image to install and configure Juju.

set -ex

# Sleep a few seconds to let the networking come up.
sleep 3
apt-get update -qq --fix-missing
# Install tools like add-apt-repository
apt-get install -qy software-properties-common
apt-add-repository -y ppa:juju/devel
# The stable ppa is required for charm-tools
apt-add-repository -y ppa:juju/stable
apt-get update -qq --fix-missing

apt-get -qy install juju-core2
apt-get -qy install byobu vim charm-tools openssh-client
apt-get -qy install virtualenvwrapper python-dev cython git

# Ubuntu user exists in the LXC images, no need to create the user.

HOME=/home/ubuntu
# Set up the Juju environment variables for the Ubuntu user.
RC=${HOME}/.bashrc
echo "export JUJU_HOME=${HOME}/.juju" >> $RC
echo "export JUJU_REPOSITORY=${HOME}" >> $RC
echo "export PROJECT_HOME=${HOME}" >> $RC
echo "export JUJU_DATA=${HOME}/.local/share/juju" >> $RC

echo "echo 'welcome to juju 2.0'" >> $RC

chown -R ubuntu:ubuntu ${HOME}
