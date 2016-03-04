#!/bin/bash

# This script runs on the LXC image to remove the build artifacts.

set -ex

apt-get remove -qy cython
apt-get remove -qy gcc
apt-get remove -qy git
apt-get remove -qy perl

apt-get autoremove -qy
apt-get autoclean -qy
apt-get clean -qy
