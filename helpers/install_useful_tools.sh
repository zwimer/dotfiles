#!/bin/bash -ex


# Apt update
apt-get update -y

# Install packages
apt-get install -y \
	ipython parallel git make gcc g++ pandoc software-properties-common vim build-essential	\
	fish zsh tmux python3-dev python-pip python-dev cmake libboost-all-dev doxygen gdb htop	\
	vagrant python3-pip apt-transport-https ca-certificates ranger gnupg-agent rlwrap irssi \
	cloc curl clang-format clang-tidy clang rsync qt5-default wget sed

# Peda
(git clone https://github.com/longld/peda.git ~/peda && echo "source ~/peda/peda.py" >> ~/.gdbinit) || true

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y

# Pwntools
pip install pwntools
