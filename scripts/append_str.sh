#!/bin/bash -eu

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
./append.sh <(echo "${1}") "${2}"
