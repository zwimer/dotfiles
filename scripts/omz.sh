#!/bin/bash -eux

export CHSH=no
export RUNZSH=no
export KEEP_ZSHRC=yes

set +x
URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
echo "Running ${URL}"
sh -c "$(curl "${URL}")"
