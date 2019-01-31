#!/bin/bash -ex

# Install packages
apt-get install -y \
	ipython parallel git make gcc g++ pandoc software-properties-common vim build-essential	\
	fish zsh tmux python3-dev python-pip python-dev cmake libboost-all-dev doxygen gdb htop	\
	vagrant python3-pip apt-transport-https ca-certificates curl gnupg-agent

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y

# Pwntools
~/.local/bin/pip install pwntools
