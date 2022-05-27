#!/bin/bash -eu

# Determien package manaer
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PM="$(./which_pm.sh)"
echo "Found package manager ${PM}"

# Update cache
if [[ "${PM}" == "apt" || "${PM}" == "apt-get" ]]; then
	./sudo.sh "${PM}" update --fix-missing -q
fi
