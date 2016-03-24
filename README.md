# Juju in LXC

This project provides a method to build a Linux Container (LXC) with [Juju](htttp://jujucharms.com) inclduing all the related tools. The system
container can be used for isolation and portability across other systems.

## Who should use this project?

This project contains a procedure to build the container with Juju inside it.
This project is useful to developers who want to build their own containers,
or fix the existing one.

If you simply want to run or use the container build with this process you can
pull the container from the image repository (link needed)

## Install

Install LXD using the package manager for your distribution.

```bash
sudo apt-get install lxd
```
Then either log out and log in again to get the user's group memebership
refreshed, or use a command to add yourself to the "lxd" group immediately:

```bash
newgrp lxd
```

Check out [linuxcontainers.org](https://linuxcontainers.org/lxd/) for more
information on LXD and how to use it.

## Download

Clone the repository from github:

```bash
git clone https://github.com/mbruzek/juju-container.git
cd juju-container
```

## Run

To build your own Juju container run the build script, then you are
able to use the container.

```bash
./build.sh
```
or
```bash
make build
```

Now that the container is build and running, you can get a shell inside it
with:

```bash
lxc exec juju-container -- /bin/bash -c 'cd /home/ubuntu/ && su ubuntu'
```
or
```bash
make bash
```
