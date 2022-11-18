#!/bin/bash -i

mkvirtualenv dotfiles_cli

set -eux
pip3 install -U pip
pip3 install quote_lines

which quote &> /dev/null # Test
./scripts/append.sh str "alias quote='$(which quote)'" ~/.shell_init
