#!/bin/bash

set -ex

lxc stop juju-container || true
lxc delete juju-container || true
lxc remote remove linuxcontainers || true
rm -f build_output.txt
