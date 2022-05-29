#!/bin/bash -eu


### Helper functions


function err() {
	>&2 echo "Error: ${1}"
	exit 1
}

function is_in() {
	local ITR MATCH="${1}"
	shift
	for ITR; do [[ "${ITR}" == "${MATCH}" ]] && return 0; done
	return 1
}

function root_do() {
	local SUDO=
	if [[ "${EUID}" -eq 0 ]]; then :;
	elif sh -c "type sudo >/dev/null 2>/dev/null"; then
		local SUDO="sudo --preserve-env=DEBIAN_FRONTEND"
	fi
	echo "Running: ${SUDO} $@"
	${SUDO} "$@"
}


### Option Functions


# Print supported commands
function help() {
	echo "Supported commands: ${SUPPORTED[@]}"
}

# Find the system package manager; store it in PM
function find_pm() {
	# Package managers listed with most preferred last
	local NEXT POSSIBLE=("yum" "apt" "apt-get" "dnf")
	for NEXT in "${POSSIBLE[@]}"; do
		type "${NEXT}" >/dev/null 2>/dev/null && PM="${NEXT}"
	done
	[[ -n "${PM:-}" ]] || err "Could not find any package manager."
}

# Install the passed packages
function install() {
	find_pm
	install_helper "${@}"
}
function install_helper() {
	local PKGS="${@}"
	local SUPPORTED=("dnf" "apt-get" "apt" "yum")
	if ! is_in "${PM}" "${SUPPORTED[@]}"; then
		err "*** Error: no suitable package manager found. ***"
	fi
	# Metadata refresh if needed
	if [[ "${PM}" == apt || "${PM}" == apt-get ]]; then
		if [[ "$(find /var/lib/apt/lists -type f | wc -l)" -eq 0 ]]; then
			root_do "${PM}" update --fix-missing -q;
		fi
	fi
	# Install
	root_do "${PM}" install -yq "$@"
}

# Install the passed packages if the package manager is $1 or $2
function install_if2() {
	local WANTED=("${1}" "${2}")
	shift 2
	find_pm
	if is_in "${PM}" "${WANTED[@]}";
	then
		install_helper "${@}"
	fi
}


## Main


CMD="${1}"
shift

SUPPORTED=("help" "root_do" "install" "install_if2")
if ! is_in "${CMD}" "${SUPPORTED[@]}"; then err "Unknown command ${CMD}"; fi

"${CMD}" "${@}"
