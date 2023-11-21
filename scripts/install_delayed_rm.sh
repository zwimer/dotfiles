#!/bin/bash -i

mkvirtualenv cli

set -eux
pip3 install -U pip
pip3 install delayed_rm

which delayed_rm &> /dev/null # Test
./scripts/append.sh str "alias rm='$(which delayed_rm)'" ~/.shell_init
