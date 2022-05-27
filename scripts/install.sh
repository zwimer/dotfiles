#!/bin/bash -eu

# Updates if no args are passed
# Tells the system package manager to install the packages named by args otherwise

# Determine package manaer
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PM="$(./which_pm.sh | tail -n1)"

# Install packages or updates as desired
if [[ "${PM}" == "apt-get" || "${PM}" == "apt" || "${PM}" == "dnf" || "${PM}" == "yum" ]]; then
	./sudo.sh "${PM}" install -yq "$@"
else
	echo "*** Error: no suitable package manager found. ***"
	exit 1
fi
