#!/bin/bash -eu

SUDO="$( dirname -- "$0" )/sudo.sh"
test -x "$SUDO"
PKG="$( dirname -- "$0" )/pkg.sh"
test -x "$PKG"

# Find vim
VIM="$(which vim || true)"
if [[ -z "$VIM" ]]; then >&2 echo "Error: Cannot find vim"; exit 1; fi

# Default vim
set -x
if command -v yum >/dev/null; then
	set +e
	"$SUDO" yum remove nano-default-editor --noautoremove \
		&& "$PKG" install_if2 dnf yum nano
	set -e
fi
"$PKG" install_if2 dnf yum vim-default-editor
git config --global core.editor "$VIM"
