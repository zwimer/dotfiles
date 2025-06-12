#!/bin/bash -eu


function root_do() {
	local SUDO=
	if [ "${EUID}" -ne 0 ] && command -v sudo >/dev/null; then
		local SUDO="sudo --preserve-env=DEBIAN_FRONTEND"
	fi
	echo "Running: $SUDO $*"
	$SUDO "$@"
}


# Find vim
VIM="$(which vim || true)"
if [[ -z "$VIM" ]]; then >&2 echo "Error: Cannot find vim"; exit 1; fi

# Setup
cd -- "$( dirname -- "$0" )"
set -x

# Default vim
if command -v yum >/dev/null; then
	( \
		root_do yum remove nano-default-editor --noautoremove \
		&& ./pkg.sh install_if2 dnf yum nano \
	) || true
fi
./pkg.sh install_if2 dnf yum vim-default-editor
git config --global core.editor "$VIM"
