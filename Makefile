build:
	# Build a container the same release as the host.
	echo "Build hash is $(shell git rev-parse HEAD)" > build_output.txt
	./build.sh 2>&1 | tee -a build_output.txt

trusty:
	echo "Building trusty $(shell git rev-parse HEAD)" > build_output.txt
	./build.sh trusty 2>&1 | tee -a build_output.txt

xenial:
	echo "Building xenial $(shell git rev-parse HEAD)" > build_output.txt
	./build.sh xenial 2>&1 | tee -a build_output.txt

publish:
	lxc stop juju-container || true
	# This publishes to your own local lxd system.
	lxc publish --public juju-container --alias=${USER}-juju-container

bash:
	lxc start juju-container || true
	# Get a bash shell on this system and run as the ubuntu user.
	lxc exec juju-container -- /bin/bash -c 'cd /home/ubuntu/ && su ubuntu'

clean:
	lxc stop juju-container || true
	lxc delete juju-container || true
	lxc remote remove linuxcontainers || true
	rm -f build_output.txt
