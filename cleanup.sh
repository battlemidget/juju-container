#!/bin/bash

# Clean up the system by removing artifacts from the build process.

set -ex

apt-get remove -qy cython
apt-get remove -qy gcc
apt-get remove -qy git
apt-get remove -qy perl

apt-get autoremove -qy
apt-get autoclean -qy
apt-get clean -qy
