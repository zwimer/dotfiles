#!/bin/bash -eu

CMD=()
if [[ "$EUID" -ne 0 ]] && command -v sudo 2>/dev/null; then
	CMD+=("sudo" "--preserve-env=DEBIAN_FRONTEND")
fi
CMD+=("$@")
set -x
exec "${CMD[@]}"
