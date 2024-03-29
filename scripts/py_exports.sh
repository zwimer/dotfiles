#!/bin/bash -eu

# virtualenvwrapper.sh is sometimes installed here
VEW="$(which virtualenvwrapper.sh || true)"
OPT="/usr/share/virtualenvwrapper/virtualenvwrapper.sh"
if [[ -f "${OPT}" ]]; then
	VEW="${OPT}"
elif [[ -z "${VEW}" ]]; then
	echo "Error: Cannot find installed virtualenvwrapper.sh"
	exit 1
fi

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -x
./append.sh str "# Configuration for virtualenv" ~/.shell_init
echo "WORKON_HOME='${HOME}/.virtualenvs'"                        >> ~/.shell_init
echo "export VIRTUALENVWRAPPER_PYTHON='$(which python3)'"        >> ~/.shell_init
echo "export VIRTUALENVWRAPPER_VIRTUALENV='$(which virtualenv)'" >> ~/.shell_init
echo "source '${VEW}'"                                           >> ~/.shell_init
