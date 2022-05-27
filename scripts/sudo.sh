#!/bin/bash -u

# This file just makes docker testing easier

SUDO=""
type sudo >/dev/null 2>/dev/null;
if [[ "${?}" -eq 0 ]]; then
	SUDO="sudo --preserve-env=DEBIAN_FRONTEND"
fi

set -x
${SUDO} "$@"
