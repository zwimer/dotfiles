#!/bin/bash -eu

VIM="$(which vim)"

if [[ -z "${VIM}" ]];
then
	echo "Cannot find vim"
	exit 1
fi

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -x
./append_str.sh "export EDITOR='${VIM}'" ~/.shell_init
git config --global core.editor "${VIM}"
