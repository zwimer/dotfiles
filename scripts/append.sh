#!/bin/bash -eux

# Args
ADD="${1}"
ADD_TO="${2}"
PREFIX="${3-}"

# Append
if [[ ! -f "${ADD_TO}" ]];
then
	cat << EOF >> "${ADD_TO}"

${PREFIX}############################################################

EOF
fi
cat "${ADD}" >> "${ADD_TO}"
