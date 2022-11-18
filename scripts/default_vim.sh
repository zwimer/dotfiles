#!/bin/bash -eu


function root_do() {
	local SUDO=
	if [[ "${EUID}" -eq 0 ]]; then :;
	elif sh -c "type sudo >/dev/null 2>/dev/null"; then
		local SUDO="sudo --preserve-env=DEBIAN_FRONTEND"
	fi
	echo "Running: ${SUDO} $@"
	${SUDO} "$@"
}


# Find vim
VIM="$(which vim || true)"
if [[ -z "${VIM}" ]];
then
	>&2 echo "Error: Cannot find vim"
	exit 1
fi

# Setup
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -x

# Default vim
YUM="$(which yum || true)"
if [[ -n "${YUM}" ]]; then
	( \
		root_do yum remove nano-default-editor --noautoremove \
		&& ./pkg.sh install_if2 dnf yum nano \
	) || true
fi
./pkg.sh install_if2 dnf yum vim-default-editor
./append.sh str "export EDITOR='${VIM}'" ~/.shell_init
git config --global core.editor "${VIM}"
