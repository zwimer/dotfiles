#!/bin/bash -eu

# ./install args[2:] if arg[1] == package manager || arg[2] == package manager

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PM="$(./which_pm.sh)"
if [[ "${PM}" == "${1}" || "${PM}" == "${2}" ]]; then
	./install.sh "${@:3}"
fi
