#!/bin/bash -u

function has() {
	type "${1}" >/dev/null 2>/dev/null;
	if [[ "${?}" -eq 0 ]]; then PM="${1}"; fi
}

# Determine which package manager
# Do in reverse order of preference
PM=
has yum
has apt
has apt-get
has dnf

if [[ -z "${PM}" ]];
then
	>&2 echo "Could not find any package manager."
	exit 1
fi

echo "${PM}"
