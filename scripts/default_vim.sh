#!/bin/bash -eu


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
./pkg.sh install_if2 dnf yum vim-default-editor
./append.sh str "export EDITOR='${VIM}'" ~/.shell_init
git config --global core.editor "${VIM}"
