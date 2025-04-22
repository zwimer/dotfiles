#!/bin/bash -eux

# Assumes argcomplete installed in venv cli

# Constants
NL='\n'
END="${NL}${NL}# ------------------- Prepend End -------------------${NL}"
FP='"${fpath[@]}"'

# Prepend to files, creating them as needed
function prepend() {
	[ -f "$1" ] || install -m 644 /dev/null "$1"
	[ -s "$1" ] || echo >> "$1"  # sed may need a non-empty file for this
	sed -i "1s|^|# Argcomplete${NL}${2}${END}|" "$1"
}

# Verify argcomplete exists
BC="$(ls -d ~/.virtualenvs/cli/lib/python3.*/site-packages/argcomplete/bash_completion.d)"
test -d "$BC"

# Prepend lines to rc files
prepend ~/.bashrc "source ${BC}/_python-argcomplete"
prepend ~/.zshrc "fpath=( ${BC} ${FP} )"
